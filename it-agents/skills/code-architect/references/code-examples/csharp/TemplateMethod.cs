// Template Method — define an algorithm skeleton in a base class with overridable steps.
using System;

namespace Patterns.TemplateMethod
{
    abstract class AbstractProcessor
    {
        // The template method defines the fixed algorithm structure.
        public string Process(string input)
        {
            string read = ReadStep(input);
            string transformed = TransformStep(read);
            return WriteStep(transformed);
        }

        protected virtual string ReadStep(string input) => $"read({input})";
        protected abstract string TransformStep(string data); // required hook
        protected virtual string WriteStep(string data) => $"write({data})";
    }

    sealed class UpperProcessor : AbstractProcessor
    {
        protected override string TransformStep(string data) => data.ToUpperInvariant();
    }

    sealed class ReverseProcessor : AbstractProcessor
    {
        protected override string TransformStep(string data)
        {
            char[] chars = data.ToCharArray();
            Array.Reverse(chars);
            return new string(chars);
        }

        // Overrides an optional step.
        protected override string WriteStep(string data) => $"out<<{data}>>";
    }

    static class Demo
    {
        public static void Run()
        {
            Console.WriteLine(new UpperProcessor().Process("abc"));
            Console.WriteLine(new ReverseProcessor().Process("abc"));
        }

        public static void Main() => Run();
    }
}
