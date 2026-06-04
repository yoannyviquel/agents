// Iterator — traverse a collection without exposing its internal representation.
using System;
using System.Collections;
using System.Collections.Generic;

namespace Patterns.Iterator
{
    // Custom aggregate that hides its storage and exposes iteration.
    sealed class RingBuffer<T> : IEnumerable<T>
    {
        private readonly T[] _items;
        private int _count;
        public RingBuffer(int capacity) => _items = new T[capacity];

        public void Add(T item)
        {
            _items[_count % _items.Length] = item;
            _count++;
        }

        // Iterator implemented as a generator; reveals nothing about storage layout.
        public IEnumerator<T> GetEnumerator()
        {
            int n = Math.Min(_count, _items.Length);
            for (int i = 0; i < n; i++)
                yield return _items[i];
        }

        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
    }

    static class Demo
    {
        public static void Run()
        {
            var buffer = new RingBuffer<string>(3);
            buffer.Add("a");
            buffer.Add("b");
            buffer.Add("c");

            foreach (string item in buffer)
                Console.WriteLine(item);
        }

        public static void Main() => Run();
    }
}
