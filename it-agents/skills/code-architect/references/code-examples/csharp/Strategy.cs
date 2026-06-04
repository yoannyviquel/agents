// Strategy — a family of interchangeable algorithms behind one interface.
using System;
using System.Collections.Generic;
using System.Linq;

namespace Patterns.Strategy
{
    interface IStrategy
    {
        IEnumerable<int> Apply(IEnumerable<int> data);
    }

    sealed class AscendingStrategy : IStrategy
    {
        public IEnumerable<int> Apply(IEnumerable<int> data) => data.OrderBy(x => x);
    }

    sealed class DescendingStrategy : IStrategy
    {
        public IEnumerable<int> Apply(IEnumerable<int> data) => data.OrderByDescending(x => x);
    }

    sealed class EvensFirstStrategy : IStrategy
    {
        public IEnumerable<int> Apply(IEnumerable<int> data) => data.OrderBy(x => x % 2 != 0).ThenBy(x => x);
    }

    // Context delegates the algorithm to the configured strategy.
    sealed class Context
    {
        private IStrategy _strategy;
        public Context(IStrategy strategy) => _strategy = strategy;
        public void SetStrategy(IStrategy strategy) => _strategy = strategy;
        public string Run(IEnumerable<int> data) => string.Join(",", _strategy.Apply(data));
    }

    static class Demo
    {
        public static void Run()
        {
            int[] data = { 3, 1, 4, 2 };
            var context = new Context(new AscendingStrategy());
            Console.WriteLine(context.Run(data));
            context.SetStrategy(new DescendingStrategy());
            Console.WriteLine(context.Run(data));
            context.SetStrategy(new EvensFirstStrategy());
            Console.WriteLine(context.Run(data));
        }

        public static void Main() => Run();
    }
}
