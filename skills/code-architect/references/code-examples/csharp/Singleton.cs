// Singleton — ensure one instance with a global access point.
using System;

namespace Patterns.Singleton
{
    sealed class Registry
    {
        // Thread-safe lazy initialization via Lazy<T>.
        private static readonly Lazy<Registry> _instance = new(() => new Registry());
        public static Registry Instance => _instance.Value;

        private int _counter;

        private Registry() { } // prevent external construction

        public int Next() => ++_counter;
    }

    static class Demo
    {
        public static void Run()
        {
            Registry a = Registry.Instance;
            Registry b = Registry.Instance;
            Console.WriteLine($"Same instance: {ReferenceEquals(a, b)}");
            Console.WriteLine(a.Next());
            Console.WriteLine(b.Next());
            Console.WriteLine(Registry.Instance.Next());
        }

        public static void Main() => Run();
    }
}
