// Facade — a simplified interface over a complex subsystem.
using System;

namespace Patterns.Facade
{
    // Subsystem parts, each with its own focused responsibility.
    sealed class SubsystemA { public string Step() => "A.ready"; }
    sealed class SubsystemB { public string Step(string input) => $"B.process({input})"; }
    sealed class SubsystemC { public string Step(string input) => $"C.finalize({input})"; }

    // Facade orchestrates the subsystems behind one simple call.
    sealed class Facade
    {
        private readonly SubsystemA _a = new();
        private readonly SubsystemB _b = new();
        private readonly SubsystemC _c = new();

        public string DoWork()
        {
            string r1 = _a.Step();
            string r2 = _b.Step(r1);
            return _c.Step(r2);
        }
    }

    static class Demo
    {
        public static void Run()
        {
            var facade = new Facade();
            Console.WriteLine(facade.DoWork());
        }

        public static void Main() => Run();
    }
}
