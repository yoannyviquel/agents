// Flyweight: share immutable intrinsic state across many objects so large
// numbers of them fit in memory, keeping extrinsic state outside.
package main

import "fmt"

// flyweight holds the shared, intrinsic state (here: a style).
type flyweight struct {
	style string
}

func (f *flyweight) Render(x, y int) string {
	return fmt.Sprintf("%s@(%d,%d)", f.style, x, y)
}

// factory ensures one flyweight per unique intrinsic key.
type factory struct {
	pool map[string]*flyweight
}

func newFactory() *factory {
	return &factory{pool: make(map[string]*flyweight)}
}

func (f *factory) get(style string) *flyweight {
	if fw, ok := f.pool[style]; ok {
		return fw
	}
	fw := &flyweight{style: style}
	f.pool[style] = fw
	return fw
}

func main() {
	f := newFactory()
	// Extrinsic coordinates differ; intrinsic style objects are reused.
	a := f.get("bold")
	b := f.get("bold")
	fmt.Println(a.Render(1, 1), b.Render(9, 9))
	fmt.Println("shared:", a == b, "| unique styles:", len(f.pool))
}
