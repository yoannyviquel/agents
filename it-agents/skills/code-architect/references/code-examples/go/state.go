// State: let an object change its behaviour when its internal state
// changes, by delegating to interchangeable state objects.
package main

import "fmt"

// State defines behaviour for one mode and may switch the context's state.
type State interface {
	Handle(c *context) string
}

// context delegates behaviour to its current state object.
type context struct {
	state State
}

func (c *context) Request() string { return c.state.Handle(c) }

type openState struct{}

func (openState) Handle(c *context) string {
	c.state = closedState{}
	return "was open -> now closed"
}

type closedState struct{}

func (closedState) Handle(c *context) string {
	c.state = openState{}
	return "was closed -> now open"
}

func main() {
	c := &context{state: openState{}}
	fmt.Println(c.Request())
	fmt.Println(c.Request())
	fmt.Println(c.Request())
}
