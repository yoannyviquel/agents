// State — let an object alter its behavior when its internal state changes.
using System;

namespace Patterns.State
{
    abstract class State
    {
        protected Context Context = null!;
        public void SetContext(Context context) => Context = context;
        public abstract string Handle();
    }

    sealed class Context
    {
        private State _state;
        public Context(State initial)
        {
            _state = initial;
            _state.SetContext(this);
        }

        public void TransitionTo(State state)
        {
            _state = state;
            _state.SetContext(this);
        }

        public string Request() => _state.Handle();
    }

    sealed class StateActive : State
    {
        public override string Handle()
        {
            Context.TransitionTo(new StateIdle());
            return "Active -> handled, now Idle";
        }
    }

    sealed class StateIdle : State
    {
        public override string Handle()
        {
            Context.TransitionTo(new StateActive());
            return "Idle -> handled, now Active";
        }
    }

    static class Demo
    {
        public static void Run()
        {
            var context = new Context(new StateIdle());
            for (int i = 0; i < 4; i++)
                Console.WriteLine(context.Request());
        }

        public static void Main() => Run();
    }
}
