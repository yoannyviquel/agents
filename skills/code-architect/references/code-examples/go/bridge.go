// Bridge: decouple an abstraction from its implementation so the two can
// vary independently.
package main

import "fmt"

// Implementor is the low-level interface the abstraction delegates to.
type Implementor interface {
	Emit(message string) string
}

type plainBackend struct{}

func (plainBackend) Emit(m string) string { return m }

type taggedBackend struct{}

func (taggedBackend) Emit(m string) string { return "[" + m + "]" }

// Abstraction holds a reference to an Implementor (the bridge).
type Abstraction struct {
	impl Implementor
}

func (a Abstraction) Show(text string) string {
	return a.impl.Emit(text)
}

// RefinedAbstraction extends behaviour without touching implementors.
type RefinedAbstraction struct {
	Abstraction
}

func (r RefinedAbstraction) ShowTwice(text string) string {
	return r.impl.Emit(text) + " " + r.impl.Emit(text)
}

func main() {
	a := Abstraction{impl: plainBackend{}}
	fmt.Println(a.Show("ping"))

	r := RefinedAbstraction{Abstraction{impl: taggedBackend{}}}
	fmt.Println(r.ShowTwice("ping"))
}
