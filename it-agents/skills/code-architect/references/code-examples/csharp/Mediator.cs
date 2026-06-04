// Mediator — centralize communication between components so they don't reference each other.
using System;
using System.Collections.Generic;

namespace Patterns.Mediator
{
    interface IMediator
    {
        void Notify(Component sender, string @event);
    }

    abstract class Component
    {
        protected IMediator Mediator = null!;
        public string Name { get; }
        protected Component(string name) => Name = name;
        public void SetMediator(IMediator mediator) => Mediator = mediator;
        public abstract void Receive(string message);
    }

    sealed class ConcreteComponent : Component
    {
        public ConcreteComponent(string name) : base(name) { }
        public void Trigger(string @event)
        {
            Console.WriteLine($"{Name} triggers '{@event}'");
            Mediator.Notify(this, @event);
        }
        public override void Receive(string message) => Console.WriteLine($"  {Name} received: {message}");
    }

    // The mediator knows all participants and routes events between them.
    sealed class ConcreteMediator : IMediator
    {
        private readonly List<Component> _components = new();
        public void Register(Component c) { c.SetMediator(this); _components.Add(c); }

        public void Notify(Component sender, string @event)
        {
            foreach (Component c in _components)
                if (!ReferenceEquals(c, sender))
                    c.Receive($"{sender.Name}:{@event}");
        }
    }

    static class Demo
    {
        public static void Run()
        {
            var mediator = new ConcreteMediator();
            var c1 = new ConcreteComponent("C1");
            var c2 = new ConcreteComponent("C2");
            var c3 = new ConcreteComponent("C3");
            mediator.Register(c1);
            mediator.Register(c2);
            mediator.Register(c3);

            c1.Trigger("ping");
        }

        public static void Main() => Run();
    }
}
