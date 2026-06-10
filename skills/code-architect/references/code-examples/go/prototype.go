// Prototype: produce new objects by cloning an existing instance instead
// of constructing them from scratch.
package main

import "fmt"

// Cloneable is anything that can copy itself.
type Cloneable interface {
	Clone() Cloneable
	Describe() string
}

// Node holds value state plus a slice to show deep copying.
type Node struct {
	label string
	tags  []string
}

func (n *Node) Clone() Cloneable {
	tags := make([]string, len(n.tags))
	copy(tags, n.tags)
	return &Node{label: n.label, tags: tags}
}

func (n *Node) Describe() string {
	return fmt.Sprintf("%s%v", n.label, n.tags)
}

func main() {
	original := &Node{label: "origin", tags: []string{"x", "y"}}
	copy := original.Clone().(*Node)
	copy.label = "copy"
	copy.tags = append(copy.tags, "z")

	fmt.Println("original:", original.Describe())
	fmt.Println("clone:   ", copy.Describe())
}
