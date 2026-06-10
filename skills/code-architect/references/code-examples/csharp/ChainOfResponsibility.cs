// Chain of Responsibility — pass a request along a chain of handlers until one handles it.
using System;

namespace Patterns.ChainOfResponsibility
{
    abstract class Handler
    {
        private Handler? _next;

        public Handler SetNext(Handler next)
        {
            _next = next;
            return next; // allow fluent chaining
        }

        public string Handle(int request)
        {
            if (CanHandle(request))
                return Process(request);
            return _next?.Handle(request) ?? $"unhandled({request})";
        }

        protected abstract bool CanHandle(int request);
        protected abstract string Process(int request);
    }

    sealed class LowHandler : Handler
    {
        protected override bool CanHandle(int r) => r < 10;
        protected override string Process(int r) => $"Low handled {r}";
    }

    sealed class MidHandler : Handler
    {
        protected override bool CanHandle(int r) => r < 100;
        protected override string Process(int r) => $"Mid handled {r}";
    }

    static class Demo
    {
        public static void Run()
        {
            var low = new LowHandler();
            low.SetNext(new MidHandler());

            foreach (int request in new[] { 5, 42, 999 })
                Console.WriteLine(low.Handle(request));
        }

        public static void Main() => Run();
    }
}
