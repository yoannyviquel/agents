// Memento: capture an object's internal state so it can be restored later
// without violating its encapsulation.
package main

import "fmt"

// memento is an opaque snapshot; only the originator reads its contents.
type memento struct {
	state string
}

// originator owns the state and creates/restores snapshots.
type originator struct {
	state string
}

func (o *originator) Set(s string) { o.state = s }

func (o *originator) Save() memento { return memento{state: o.state} }

func (o *originator) Restore(m memento) { o.state = m.state }

// caretaker stores snapshots but never inspects them.
type caretaker struct {
	history []memento
}

func (c *caretaker) push(m memento) { c.history = append(c.history, m) }

func (c *caretaker) pop() memento {
	n := len(c.history) - 1
	m := c.history[n]
	c.history = c.history[:n]
	return m
}

func main() {
	o := &originator{}
	care := &caretaker{}

	o.Set("draft")
	care.push(o.Save())

	o.Set("edited")
	fmt.Println("current:", o.state)

	o.Restore(care.pop())
	fmt.Println("restored:", o.state)
}
