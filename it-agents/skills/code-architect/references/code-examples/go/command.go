// Command: encapsulate a request as an object, enabling queuing, logging
// and undo of operations.
package main

import "fmt"

// receiver holds the state that commands act upon.
type receiver struct {
	value int
}

// Command is an action plus its inverse.
type Command interface {
	Execute()
	Undo()
}

type addCommand struct {
	target *receiver
	amount int
}

func (c addCommand) Execute() { c.target.value += c.amount }
func (c addCommand) Undo()    { c.target.value -= c.amount }

// invoker runs commands and keeps history for undo.
type invoker struct {
	history []Command
}

func (i *invoker) Run(c Command) {
	c.Execute()
	i.history = append(i.history, c)
}

func (i *invoker) UndoLast() {
	if n := len(i.history); n > 0 {
		i.history[n-1].Undo()
		i.history = i.history[:n-1]
	}
}

func main() {
	r := &receiver{}
	inv := &invoker{}

	inv.Run(addCommand{target: r, amount: 5})
	inv.Run(addCommand{target: r, amount: 3})
	fmt.Println("after run:", r.value)

	inv.UndoLast()
	fmt.Println("after undo:", r.value)
}
