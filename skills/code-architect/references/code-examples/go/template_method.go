// Template Method: define the skeleton of an algorithm in a fixed order,
// deferring individual steps to overridable implementations.
package main

import "fmt"

// steps are the customisable parts of the algorithm.
type steps interface {
	acquire() string
	transform(string) string
}

// run is the invariant template: it fixes the order of the steps.
func run(s steps) string {
	raw := s.acquire()
	return s.transform(raw)
}

// upperFlow is one concrete implementation of the steps.
type upperFlow struct{}

func (upperFlow) acquire() string             { return "abc" }
func (upperFlow) transform(in string) string  { return "UP:" + in }

// reverseFlow is another implementation reusing the same template.
type reverseFlow struct{}

func (reverseFlow) acquire() string            { return "xyz" }
func (reverseFlow) transform(in string) string { return "REV:" + in }

func main() {
	fmt.Println(run(upperFlow{}))
	fmt.Println(run(reverseFlow{}))
}
