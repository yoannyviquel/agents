// Proxy — a placeholder controlling access to a real object (here: lazy creation + caching).
using System;
using System.Collections.Generic;

namespace Patterns.Proxy
{
    interface IService
    {
        string Fetch(string key);
    }

    // Expensive-to-build real subject.
    sealed class RealService : IService
    {
        public RealService() => Console.WriteLine("[RealService constructed]");
        public string Fetch(string key) => $"value-for-{key}";
    }

    // Proxy defers construction and caches results.
    sealed class CachingProxy : IService
    {
        private RealService? _real;
        private readonly Dictionary<string, string> _cache = new();

        public string Fetch(string key)
        {
            if (_cache.TryGetValue(key, out string? cached))
                return $"{cached} (cached)";

            _real ??= new RealService(); // lazy init on first real need
            string result = _real.Fetch(key);
            _cache[key] = result;
            return result;
        }
    }

    static class Demo
    {
        public static void Run()
        {
            IService service = new CachingProxy();
            Console.WriteLine("Proxy created; no real service yet.");
            Console.WriteLine(service.Fetch("x"));
            Console.WriteLine(service.Fetch("x"));
            Console.WriteLine(service.Fetch("y"));
        }

        public static void Main() => Run();
    }
}
