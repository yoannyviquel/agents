// Flyweight — share intrinsic state across many objects to save memory.
using System;
using System.Collections.Generic;

namespace Patterns.Flyweight
{
    // Intrinsic, shareable state.
    sealed class Flyweight
    {
        private readonly string _sharedState;
        public Flyweight(string sharedState) => _sharedState = sharedState;

        // Extrinsic state is passed in by the caller, not stored.
        public string Operation(string extrinsic) => $"{_sharedState}#{extrinsic}";
    }

    sealed class FlyweightFactory
    {
        private readonly Dictionary<string, Flyweight> _pool = new();

        public Flyweight Get(string key)
        {
            if (!_pool.TryGetValue(key, out Flyweight? fw))
            {
                fw = new Flyweight(key);
                _pool[key] = fw;
            }
            return fw;
        }

        public int DistinctCount => _pool.Count;
    }

    static class Demo
    {
        public static void Run()
        {
            var factory = new FlyweightFactory();
            string[] keys = { "red", "red", "blue", "red", "blue" };
            int i = 0;
            foreach (string key in keys)
                Console.WriteLine(factory.Get(key).Operation($"ctx{i++}"));

            Console.WriteLine($"Distinct flyweights stored: {factory.DistinctCount}");
        }

        public static void Main() => Run();
    }
}
