// Factory Method: a creator method returns products via an interface,
// letting subclasses decide which concrete product to build.
package main

import "fmt"

// Product is the common interface returned by every factory.
type Product interface {
	Operate() string
}

type alphaProduct struct{}

func (alphaProduct) Operate() string { return "alpha behaviour" }

type betaProduct struct{}

func (betaProduct) Operate() string { return "beta behaviour" }

// Creator declares the factory method; concrete creators override it.
type Creator interface {
	Make() Product
}

type alphaCreator struct{}

func (alphaCreator) Make() Product { return alphaProduct{} }

type betaCreator struct{}

func (betaCreator) Make() Product { return betaProduct{} }

func describe(c Creator) string {
	return c.Make().Operate()
}

func main() {
	creators := []Creator{alphaCreator{}, betaCreator{}}
	for _, c := range creators {
		fmt.Println(describe(c))
	}
}
