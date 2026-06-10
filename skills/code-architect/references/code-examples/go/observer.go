// Observer: define a subscription mechanism so multiple observers are
// notified automatically when a subject's state changes.
package main

import "fmt"

// Observer reacts to notifications from a subject.
type Observer interface {
	Update(event string)
}

// subject maintains a list of observers and broadcasts to them.
type subject struct {
	observers []Observer
}

func (s *subject) Subscribe(o Observer) {
	s.observers = append(s.observers, o)
}

func (s *subject) Publish(event string) {
	for _, o := range s.observers {
		o.Update(event)
	}
}

// logger is a concrete observer that records what it hears.
type logger struct {
	name string
	seen []string
}

func (l *logger) Update(event string) {
	l.seen = append(l.seen, event)
	fmt.Printf("%s received %q\n", l.name, event)
}

func main() {
	s := &subject{}
	s.Subscribe(&logger{name: "first"})
	s.Subscribe(&logger{name: "second"})

	s.Publish("state-changed")
}
