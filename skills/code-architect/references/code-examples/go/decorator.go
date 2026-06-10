// Decorator: attach extra responsibilities to an object dynamically by
// wrapping it in objects sharing the same interface.
package main

import "fmt"

// Component is the interface shared by the core and all decorators.
type Component interface {
	Process(input string) string
}

// core is the base behaviour being decorated.
type core struct{}

func (core) Process(input string) string { return input }

// trimDecorator wraps a component and adds trimming-like framing.
type trimDecorator struct {
	inner Component
}

func (d trimDecorator) Process(input string) string {
	return "<" + d.inner.Process(input) + ">"
}

// repeatDecorator wraps a component and duplicates the result.
type repeatDecorator struct {
	inner Component
}

func (d repeatDecorator) Process(input string) string {
	out := d.inner.Process(input)
	return out + out
}

func main() {
	var c Component = core{}
	c = trimDecorator{inner: c}
	c = repeatDecorator{inner: c}
	fmt.Println(c.Process("data"))
}
