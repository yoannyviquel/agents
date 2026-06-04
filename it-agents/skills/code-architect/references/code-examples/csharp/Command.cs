// Command — encapsulate a request as an object; supports undo.
using System;
using System.Collections.Generic;

namespace Patterns.Command
{
    // Receiver holds the state the commands act upon.
    sealed class Receiver
    {
        public int Value { get; private set; }
        public void Apply(int delta) => Value += delta;
    }

    interface ICommand
    {
        void Execute();
        void Undo();
    }

    sealed class AddCommand : ICommand
    {
        private readonly Receiver _receiver;
        private readonly int _amount;
        public AddCommand(Receiver receiver, int amount)
        {
            _receiver = receiver;
            _amount = amount;
        }
        public void Execute() => _receiver.Apply(_amount);
        public void Undo() => _receiver.Apply(-_amount);
    }

    // Invoker keeps a history to support undo.
    sealed class Invoker
    {
        private readonly Stack<ICommand> _history = new();
        public void Run(ICommand command)
        {
            command.Execute();
            _history.Push(command);
        }
        public void Undo()
        {
            if (_history.Count > 0) _history.Pop().Undo();
        }
    }

    static class Demo
    {
        public static void Run()
        {
            var receiver = new Receiver();
            var invoker = new Invoker();
            invoker.Run(new AddCommand(receiver, 5));
            invoker.Run(new AddCommand(receiver, 3));
            Console.WriteLine($"After commands: {receiver.Value}");
            invoker.Undo();
            Console.WriteLine($"After undo: {receiver.Value}");
        }

        public static void Main() => Run();
    }
}
