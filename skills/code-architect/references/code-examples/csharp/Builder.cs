// Builder — construct complex objects step by step.
using System;
using System.Collections.Generic;
using System.Text;

namespace Patterns.Builder
{
    sealed class Product
    {
        public List<string> Parts { get; } = new();
        public string Report()
        {
            var sb = new StringBuilder("Product{");
            sb.Append(string.Join(", ", Parts));
            return sb.Append('}').ToString();
        }
    }

    interface IBuilder
    {
        IBuilder Reset();
        IBuilder AddPartA();
        IBuilder AddPartB();
        IBuilder AddPartC();
        Product Build();
    }

    sealed class ConcreteBuilder : IBuilder
    {
        private Product _product = new();
        public IBuilder Reset() { _product = new Product(); return this; }
        public IBuilder AddPartA() { _product.Parts.Add("PartA"); return this; }
        public IBuilder AddPartB() { _product.Parts.Add("PartB"); return this; }
        public IBuilder AddPartC() { _product.Parts.Add("PartC"); return this; }
        public Product Build() { Product result = _product; Reset(); return result; }
    }

    // Director encapsulates known construction recipes.
    sealed class Director
    {
        public Product BuildMinimal(IBuilder b) => b.Reset().AddPartA().Build();
        public Product BuildFull(IBuilder b) => b.Reset().AddPartA().AddPartB().AddPartC().Build();
    }

    static class Demo
    {
        public static void Run()
        {
            var builder = new ConcreteBuilder();
            var director = new Director();
            Console.WriteLine(director.BuildMinimal(builder).Report());
            Console.WriteLine(director.BuildFull(builder).Report());
            // Custom assembly without the director:
            Console.WriteLine(builder.Reset().AddPartB().AddPartC().Build().Report());
        }

        public static void Main() => Run();
    }
}
