// Observer — subscription mechanism to notify subscribers of events.
using System;
using System.Collections.Generic;

namespace Patterns.Observer
{
    interface IObserver
    {
        void Update(int state);
    }

    interface ISubject
    {
        void Subscribe(IObserver observer);
        void Unsubscribe(IObserver observer);
        void Notify();
    }

    sealed class Subject : ISubject
    {
        private readonly List<IObserver> _observers = new();
        private int _state;

        public int State
        {
            get => _state;
            set { _state = value; Notify(); }
        }

        public void Subscribe(IObserver observer) => _observers.Add(observer);
        public void Unsubscribe(IObserver observer) => _observers.Remove(observer);
        public void Notify()
        {
            foreach (IObserver o in _observers.ToArray())
                o.Update(_state);
        }
    }

    sealed class ConcreteObserver : IObserver
    {
        private readonly string _name;
        public ConcreteObserver(string name) => _name = name;
        public void Update(int state) => Console.WriteLine($"{_name} notified of state {state}");
    }

    static class Demo
    {
        public static void Run()
        {
            var subject = new Subject();
            var a = new ConcreteObserver("A");
            var b = new ConcreteObserver("B");
            subject.Subscribe(a);
            subject.Subscribe(b);

            subject.State = 1;
            subject.Unsubscribe(a);
            subject.State = 2;
        }

        public static void Main() => Run();
    }
}
