// Composite: compose objects into tree structures and treat individual
// leaves and whole groups through one uniform interface.
package main

import "fmt"

// Component is the shared interface for leaves and containers.
type Component interface {
	Size() int
}

// Leaf is a primitive element with no children.
type Leaf struct {
	weight int
}

func (l Leaf) Size() int { return l.weight }

// Container holds children and aggregates their sizes recursively.
type Container struct {
	children []Component
}

func (c *Container) Add(child Component) {
	c.children = append(c.children, child)
}

func (c *Container) Size() int {
	total := 0
	for _, child := range c.children {
		total += child.Size()
	}
	return total
}

func main() {
	root := &Container{}
	root.Add(Leaf{weight: 3})

	sub := &Container{}
	sub.Add(Leaf{weight: 5})
	sub.Add(Leaf{weight: 2})
	root.Add(sub)

	fmt.Println("total size:", root.Size())
}
