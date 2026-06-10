// Iterator: traverse the elements of a collection sequentially without
// exposing its underlying representation.
package main

import "fmt"

// Iterator yields elements one at a time.
type Iterator interface {
	HasNext() bool
	Next() string
}

// collection hides its storage behind an iterator factory.
type collection struct {
	items []string
}

func (c *collection) Iterator() Iterator {
	return &cursor{coll: c}
}

// cursor tracks the current position over the collection.
type cursor struct {
	coll *collection
	pos  int
}

func (it *cursor) HasNext() bool { return it.pos < len(it.coll.items) }

func (it *cursor) Next() string {
	item := it.coll.items[it.pos]
	it.pos++
	return item
}

func main() {
	c := &collection{items: []string{"one", "two", "three"}}
	for it := c.Iterator(); it.HasNext(); {
		fmt.Println(it.Next())
	}
}
