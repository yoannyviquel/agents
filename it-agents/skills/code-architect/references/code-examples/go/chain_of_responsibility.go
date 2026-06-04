// Chain of Responsibility: pass a request along a chain of handlers until
// one of them handles it.
package main

import "fmt"

// Handler links to the next handler and tries to process a request.
type Handler interface {
	SetNext(Handler) Handler
	Handle(level int) string
}

// base provides the shared next-link forwarding logic.
type base struct {
	next Handler
}

func (b *base) SetNext(h Handler) Handler {
	b.next = h
	return h
}

func (b *base) forward(level int) string {
	if b.next != nil {
		return b.next.Handle(level)
	}
	return "unhandled"
}

type lowHandler struct{ base }

func (h *lowHandler) Handle(level int) string {
	if level <= 1 {
		return "low handled"
	}
	return h.forward(level)
}

type highHandler struct{ base }

func (h *highHandler) Handle(level int) string {
	if level <= 5 {
		return "high handled"
	}
	return h.forward(level)
}

func main() {
	low, high := &lowHandler{}, &highHandler{}
	low.SetNext(high)

	for _, lvl := range []int{1, 4, 9} {
		fmt.Printf("level %d -> %s\n", lvl, low.Handle(lvl))
	}
}
