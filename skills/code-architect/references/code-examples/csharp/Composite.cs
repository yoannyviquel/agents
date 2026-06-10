// Composite — compose objects into trees, treat leaf and container uniformly.
using System;
using System.Collections.Generic;

namespace Patterns.Composite
{
    abstract class Component
    {
        public string Name { get; }
        protected Component(string name) => Name = name;
        public abstract int Weight();
        public abstract string Render(int indent);
    }

    sealed class Leaf : Component
    {
        private readonly int _weight;
        public Leaf(string name, int weight) : base(name) => _weight = weight;
        public override int Weight() => _weight;
        public override string Render(int indent) => $"{new string(' ', indent)}- {Name} ({_weight})";
    }

    sealed class Composite : Component
    {
        private readonly List<Component> _children = new();
        public Composite(string name) : base(name) { }
        public Composite Add(Component child) { _children.Add(child); return this; }

        public override int Weight()
        {
            int sum = 0;
            foreach (Component c in _children) sum += c.Weight();
            return sum;
        }

        public override string Render(int indent)
        {
            var lines = new List<string> { $"{new string(' ', indent)}+ {Name} ({Weight()})" };
            foreach (Component c in _children) lines.Add(c.Render(indent + 2));
            return string.Join(Environment.NewLine, lines);
        }
    }

    static class Demo
    {
        public static void Run()
        {
            var root = new Composite("root")
                .Add(new Leaf("a", 1))
                .Add(new Composite("group")
                    .Add(new Leaf("b", 2))
                    .Add(new Leaf("c", 3)));
            Console.WriteLine(root.Render(0));
        }

        public static void Main() => Run();
    }
}
