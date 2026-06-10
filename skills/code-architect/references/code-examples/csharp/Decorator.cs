// Decorator — attach responsibilities by wrapping objects at runtime.
using System;

namespace Patterns.Decorator
{
    interface IComponent
    {
        string Operation();
    }

    sealed class ConcreteComponent : IComponent
    {
        public string Operation() => "core";
    }

    abstract class Decorator : IComponent
    {
        protected readonly IComponent Inner;
        protected Decorator(IComponent inner) => Inner = inner;
        public abstract string Operation();
    }

    sealed class UpperDecorator : Decorator
    {
        public UpperDecorator(IComponent inner) : base(inner) { }
        public override string Operation() => Inner.Operation().ToUpperInvariant();
    }

    sealed class BracketDecorator : Decorator
    {
        public BracketDecorator(IComponent inner) : base(inner) { }
        public override string Operation() => $"[{Inner.Operation()}]";
    }

    static class Demo
    {
        public static void Run()
        {
            IComponent plain = new ConcreteComponent();
            Console.WriteLine(plain.Operation());

            // Stack decorators dynamically; order matters.
            IComponent wrapped = new BracketDecorator(new UpperDecorator(plain));
            Console.WriteLine(wrapped.Operation());
        }

        public static void Main() => Run();
    }
}
