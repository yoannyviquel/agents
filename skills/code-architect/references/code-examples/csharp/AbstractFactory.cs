// Abstract Factory — create families of related objects without specifying concrete classes.
using System;

namespace Patterns.AbstractFactory
{
    interface IElementX { string Tag(); }
    interface IElementY { string Tag(); }

    interface IFamilyFactory
    {
        IElementX CreateX();
        IElementY CreateY();
    }

    // Family 1
    sealed class Family1X : IElementX { public string Tag() => "X[Family1]"; }
    sealed class Family1Y : IElementY { public string Tag() => "Y[Family1]"; }
    sealed class Family1Factory : IFamilyFactory
    {
        public IElementX CreateX() => new Family1X();
        public IElementY CreateY() => new Family1Y();
    }

    // Family 2
    sealed class Family2X : IElementX { public string Tag() => "X[Family2]"; }
    sealed class Family2Y : IElementY { public string Tag() => "Y[Family2]"; }
    sealed class Family2Factory : IFamilyFactory
    {
        public IElementX CreateX() => new Family2X();
        public IElementY CreateY() => new Family2Y();
    }

    // Client code depends only on the abstract factory and product interfaces.
    sealed class Client
    {
        private readonly IElementX _x;
        private readonly IElementY _y;
        public Client(IFamilyFactory factory)
        {
            _x = factory.CreateX();
            _y = factory.CreateY();
        }
        public string Combine() => $"{_x.Tag()} + {_y.Tag()}";
    }

    static class Demo
    {
        public static void Run()
        {
            Console.WriteLine(new Client(new Family1Factory()).Combine());
            Console.WriteLine(new Client(new Family2Factory()).Combine());
        }

        public static void Main() => Run();
    }
}
