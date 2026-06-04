// Visitor — separate algorithms from the objects they operate on via accept/visit (double dispatch).
using System;
using System.Collections.Generic;

namespace Patterns.Visitor
{
    interface IVisitor
    {
        string Visit(ElementA element);
        string Visit(ElementB element);
    }

    abstract class Element
    {
        public abstract string Accept(IVisitor visitor);
    }

    sealed class ElementA : Element
    {
        public int Number { get; } = 7;
        public override string Accept(IVisitor visitor) => visitor.Visit(this);
    }

    sealed class ElementB : Element
    {
        public string Text { get; } = "node";
        public override string Accept(IVisitor visitor) => visitor.Visit(this);
    }

    // A concrete operation defined entirely outside the element classes.
    sealed class DescribeVisitor : IVisitor
    {
        public string Visit(ElementA element) => $"A holds number {element.Number}";
        public string Visit(ElementB element) => $"B holds text '{element.Text}'";
    }

    static class Demo
    {
        public static void Run()
        {
            var elements = new List<Element> { new ElementA(), new ElementB() };
            var visitor = new DescribeVisitor();
            foreach (Element element in elements)
                Console.WriteLine(element.Accept(visitor));
        }

        public static void Main() => Run();
    }
}
