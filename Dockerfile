# Stage 1: Base image (runtime) - Configuração única do SSH
FROM mcr.microsoft.com/dotnet/runtime:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 80  # Porta do app .NET
EXPOSE 22  # Porta do SSH

# Instala SSH e net-tools UMA ÚNICA VEZ (no estágio base)
RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-server net-tools && \
    mkdir -p /run/sshd && \
    rm -rf /var/lib/apt/lists/* && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Stages de build e publish (mantidos originais)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["calculadora.csproj", "."]
RUN dotnet restore "./calculadora.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./calculadora.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./calculadora.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Stage final: Herda tudo do estágio "base" e adiciona o app .NET
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Inicia SSH em segundo plano + aplicativo .NET
CMD mkdir -p /run/sshd && /usr/sbin/sshd -D & dotnet calculadora.dll