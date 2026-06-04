// Adapter — make an incompatible interface usable via a wrapper.
using System;

namespace Patterns.Adapter
{
    // The interface the client expects.
    interface ITarget
    {
        string Request();
    }

    // Pre-existing class with an incompatible interface (cannot be changed).
    sealed class Adaptee
    {
        public string SpecificRequest() => "raw-payload";
    }

    // Adapter translates Target calls into Adaptee calls.
    sealed class Adapter : ITarget
    {
        private readonly Adaptee _adaptee;
        public Adapter(Adaptee adaptee) => _adaptee = adaptee;

        public string Request()
        {
            string raw = _adaptee.SpecificRequest();
            return $"adapted({raw})";
        }
    }

    static class Demo
    {
        public static void Run()
        {
            ITarget target = new Adapter(new Adaptee());
            Console.WriteLine(target.Request());
        }

        public static void Main() => Run();
    }
}
