namespace calculadora
{
    public class Program
    {
        static void Main(string[] args)
        {
            for (int i = 0; i < 1440; i++) {
                Console.WriteLine("Hello, World! o deploy automatico deu certoo");
                var calculadora = new Calculadora();
                var resultado = calculadora.Somar(1, 1);
                Console.WriteLine(resultado.ToString());
                Thread.Sleep(60000);
            }

        }
    }
}
