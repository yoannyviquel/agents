// Visitor: separate algorithms from the object structure they operate on,
// using double dispatch via accept/visit.
package main

import "fmt"

// Visitor declares one visit method per concrete element type.
type Visitor interface {
	VisitCircle(c circle) string
	VisitSquare(s square) string
}

// Element accepts a visitor and routes to the right visit method.
type Element interface {
	Accept(v Visitor) string
}

type circle struct{ radius int }

func (c circle) Accept(v Visitor) string { return v.VisitCircle(c) }

type square struct{ side int }

func (s square) Accept(v Visitor) string { return v.VisitSquare(s) }

// areaVisitor is one algorithm defined entirely outside the elements.
type areaVisitor struct{}

func (areaVisitor) VisitCircle(c circle) string {
	return fmt.Sprintf("circle area ~= %d", 3*c.radius*c.radius)
}

func (areaVisitor) VisitSquare(s square) string {
	return fmt.Sprintf("square area = %d", s.side*s.side)
}

func main() {
	elements := []Element{circle{radius: 2}, square{side: 3}}
	v := areaVisitor{}
	for _, e := range elements {
		fmt.Println(e.Accept(v))
	}
}
