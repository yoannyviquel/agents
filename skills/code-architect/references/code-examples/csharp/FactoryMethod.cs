// Factory Method — subclasses decide which product class to instantiate via a factory method.
using System;

namespace Patterns.FactoryMethod
{
    interface IProduct
    {
        string Describe();
    }

    sealed class ConcreteProductA : IProduct
    {
        public string Describe() => "Product A";
    }

    sealed class ConcreteProductB : IProduct
    {
        public string Describe() => "Product B";
    }

    abstract class Creator
    {
        // The factory method: subclasses supply the concrete product.
        protected abstract IProduct CreateProduct();

        // Higher-level logic relying on the product, agnostic of its concrete type.
        public string Operate()
        {
            IProduct product = CreateProduct();
            return $"Creator built [{product.Describe()}]";
        }
    }

    sealed class CreatorA : Creator
    {
        protected override IProduct CreateProduct() => new ConcreteProductA();
    }

    sealed class CreatorB : Creator
    {
        protected override IProduct CreateProduct() => new ConcreteProductB();
    }

    static class Demo
    {
        public static void Run()
        {
            Creator[] creators = { new CreatorA(), new CreatorB() };
            foreach (Creator creator in creators)
                Console.WriteLine(creator.Operate());
        }

        public static void Main() => Run();
    }
}
