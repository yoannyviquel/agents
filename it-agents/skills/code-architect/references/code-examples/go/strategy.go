// Strategy: define a family of interchangeable algorithms behind a common
// interface and select one at runtime.
package main

import "fmt"

// Strategy is the common interface for interchangeable algorithms.
type Strategy interface {
	Combine(a, b int) int
}

type sumStrategy struct{}

func (sumStrategy) Combine(a, b int) int { return a + b }

type maxStrategy struct{}

func (maxStrategy) Combine(a, b int) int {
	if a > b {
		return a
	}
	return b
}

// context delegates the work to whichever strategy it holds.
type context struct {
	strategy Strategy
}

func (c *context) Execute(a, b int) int {
	return c.strategy.Combine(a, b)
}

func main() {
	c := &context{strategy: sumStrategy{}}
	fmt.Println("sum:", c.Execute(3, 7))

	c.strategy = maxStrategy{}
	fmt.Println("max:", c.Execute(3, 7))
}
