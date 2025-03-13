namespace calculadora
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello, World!");
            var calculadora = new Calculadora();
            var resultado = calculadora.Somar(1, 1);
            Console.WriteLine(resultado.ToString());
        }
    }
}
