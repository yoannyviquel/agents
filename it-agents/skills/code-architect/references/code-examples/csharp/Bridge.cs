// Bridge — split abstraction and implementation into independent hierarchies.
using System;

namespace Patterns.Bridge
{
    // Implementation hierarchy
    interface IImplementor
    {
        string LowLevelOp();
    }

    sealed class ImplementorRed : IImplementor
    {
        public string LowLevelOp() => "red-backend";
    }

    sealed class ImplementorBlue : IImplementor
    {
        public string LowLevelOp() => "blue-backend";
    }

    // Abstraction hierarchy, decoupled from the implementation via composition.
    abstract class Abstraction
    {
        protected readonly IImplementor Impl;
        protected Abstraction(IImplementor impl) => Impl = impl;
        public abstract string Operation();
    }

    sealed class BasicAbstraction : Abstraction
    {
        public BasicAbstraction(IImplementor impl) : base(impl) { }
        public override string Operation() => $"basic -> {Impl.LowLevelOp()}";
    }

    sealed class ExtendedAbstraction : Abstraction
    {
        public ExtendedAbstraction(IImplementor impl) : base(impl) { }
        public override string Operation() => $"extended[+] -> {Impl.LowLevelOp()}";
    }

    static class Demo
    {
        public static void Run()
        {
            // Mix and match abstractions with implementations freely.
            Abstraction a = new BasicAbstraction(new ImplementorRed());
            Abstraction b = new ExtendedAbstraction(new ImplementorBlue());
            Console.WriteLine(a.Operation());
            Console.WriteLine(b.Operation());
        }

        public static void Main() => Run();
    }
}
