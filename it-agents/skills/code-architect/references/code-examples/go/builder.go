// Builder: construct a complex object step by step, allowing the same
// process to assemble different representations.
package main

import (
	"fmt"
	"strings"
)

// Result is the complex object being assembled.
type Result struct {
	parts []string
}

func (r Result) String() string { return strings.Join(r.parts, " + ") }

// Builder defines the assembly steps; it returns itself for chaining.
type Builder struct {
	r Result
}

func NewBuilder() *Builder { return &Builder{} }

func (b *Builder) AddBase(name string) *Builder {
	b.r.parts = append(b.r.parts, "base:"+name)
	return b
}

func (b *Builder) AddLayer(name string) *Builder {
	b.r.parts = append(b.r.parts, "layer:"+name)
	return b
}

func (b *Builder) Build() Result { return b.r }

// Director encapsulates a known recipe of steps.
func directStandard(b *Builder) Result {
	return b.AddBase("core").AddLayer("cache").AddLayer("auth").Build()
}

func main() {
	custom := NewBuilder().AddBase("core").AddLayer("logging").Build()
	fmt.Println("custom:", custom)
	fmt.Println("directed:", directStandard(NewBuilder()))
}
