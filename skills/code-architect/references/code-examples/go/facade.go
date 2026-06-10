// Facade: expose a single simplified entry point that hides the wiring of
// a more complex subsystem.
package main

import "fmt"

// Subsystem pieces, each with its own narrow responsibility.
type loader struct{}

func (loader) load() string { return "raw" }

type parser struct{}

func (parser) parse(in string) string { return in + "-parsed" }

type validator struct{}

func (validator) validate(in string) bool { return in != "" }

// Facade orchestrates the subsystem behind one method.
type Pipeline struct {
	l loader
	p parser
	v validator
}

func (pl Pipeline) Run() (string, bool) {
	data := pl.p.parse(pl.l.load())
	return data, pl.v.validate(data)
}

func main() {
	out, ok := Pipeline{}.Run()
	fmt.Println(out, ok)
}
