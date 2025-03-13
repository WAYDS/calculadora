namespace calculadora
{
    internal class Program
    {
        static void Main(string[] args)
        {
            for (int i = 0; i < 5; i++) {
                Console.WriteLine("Hello, World!");
                var calculadora = new Calculadora();
                var resultado = calculadora.Somar(1, 1);
                Console.WriteLine(resultado.ToString());
                Thread.Sleep(1000);
            }

        }
    }
}
