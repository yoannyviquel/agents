// Prototype — copy existing objects via a clone interface without coupling to their classes.
using System;
using System.Collections.Generic;

namespace Patterns.Prototype
{
    interface IPrototype<T>
    {
        T Clone();
    }

    sealed class ConcretePrototype : IPrototype<ConcretePrototype>
    {
        public string Label { get; set; }
        public List<int> Values { get; set; }

        public ConcretePrototype(string label, List<int> values)
        {
            Label = label;
            Values = values;
        }

        // Deep copy: mutable members are duplicated, not shared.
        public ConcretePrototype Clone() => new(Label, new List<int>(Values));

        public override string ToString() => $"{Label}:[{string.Join(",", Values)}]";
    }

    static class Demo
    {
        public static void Run()
        {
            var original = new ConcretePrototype("origin", new List<int> { 1, 2, 3 });
            ConcretePrototype copy = original.Clone();
            copy.Label = "copy";
            copy.Values.Add(4);

            Console.WriteLine(original); // unaffected by changes to copy
            Console.WriteLine(copy);
        }

        public static void Main() => Run();
    }
}
