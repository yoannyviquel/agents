// Singleton: ensure a type has exactly one instance with a global access
// point, initialised lazily and safely with sync.Once.
package main

import (
	"fmt"
	"sync"
)

// registry is the single shared instance.
type registry struct {
	entries map[string]int
}

var (
	instance *registry
	once     sync.Once
)

// Instance returns the one and only registry, building it on first use.
func Instance() *registry {
	once.Do(func() {
		instance = &registry{entries: make(map[string]int)}
	})
	return instance
}

func (r *registry) Add(key string) { r.entries[key]++ }

func main() {
	Instance().Add("hit")
	Instance().Add("hit")

	// Both lookups return the very same pointer.
	a, b := Instance(), Instance()
	fmt.Println("same instance:", a == b)
	fmt.Println("count:", b.entries["hit"])
}
