# Stage 1: Base image (runtime)
FROM mcr.microsoft.com/dotnet/runtime:8.0 AS base

WORKDIR /app
EXPOSE 80
EXPOSE 22 

# Instala SSH e net-tools como root
RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-server net-tools && \
    mkdir -p /run/sshd && \
    rm -rf /var/lib/apt/lists/* && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Stages de build e publish
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

# Stage final
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Inicia SSH + app .NET
CMD ["bash", "-c", "/usr/sbin/sshd -D & exec dotnet calculadora.dll"]

