// Memento — capture and restore an object's state without breaking encapsulation.
using System;
using System.Collections.Generic;

namespace Patterns.Memento
{
    // Opaque snapshot; the originator alone interprets its contents.
    sealed class Memento
    {
        public string State { get; }
        public Memento(string state) => State = state;
    }

    sealed class Originator
    {
        public string State { get; set; } = "";
        public Memento Save() => new(State);
        public void Restore(Memento memento) => State = memento.State;
    }

    // Caretaker stores mementos but never inspects their internals.
    sealed class Caretaker
    {
        private readonly Stack<Memento> _history = new();
        public void Backup(Originator o) => _history.Push(o.Save());
        public void Undo(Originator o)
        {
            if (_history.Count > 0) o.Restore(_history.Pop());
        }
    }

    static class Demo
    {
        public static void Run()
        {
            var originator = new Originator();
            var caretaker = new Caretaker();

            originator.State = "v1";
            caretaker.Backup(originator);
            originator.State = "v2";
            caretaker.Backup(originator);
            originator.State = "v3";
            Console.WriteLine($"Current: {originator.State}");

            caretaker.Undo(originator);
            Console.WriteLine($"After undo: {originator.State}");
            caretaker.Undo(originator);
            Console.WriteLine($"After undo: {originator.State}");
        }

        public static void Main() => Run();
    }
}
