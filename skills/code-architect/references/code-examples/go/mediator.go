// Mediator: centralise the communication between components so they refer
// to the mediator instead of to each other directly.
package main

import "fmt"

// Mediator coordinates colleagues; they never talk to each other directly.
type Mediator interface {
	Notify(sender string, event string)
}

// colleague holds a back-reference to its mediator.
type colleague struct {
	name      string
	mediator  Mediator
	lastHeard string
}

func (c *colleague) Send(event string) {
	c.mediator.Notify(c.name, event)
}

// hub is the concrete mediator wiring colleagues together.
type hub struct {
	members map[string]*colleague
}

func (h *hub) register(c *colleague) {
	c.mediator = h
	h.members[c.name] = c
}

func (h *hub) Notify(sender, event string) {
	for name, c := range h.members {
		if name != sender {
			c.lastHeard = sender + ":" + event
		}
	}
}

func main() {
	h := &hub{members: map[string]*colleague{}}
	a := &colleague{name: "A"}
	b := &colleague{name: "B"}
	h.register(a)
	h.register(b)

	a.Send("ping")
	fmt.Println("B heard:", b.lastHeard)
}
