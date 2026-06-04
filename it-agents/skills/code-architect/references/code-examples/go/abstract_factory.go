// Abstract Factory: create families of related objects without naming
// their concrete types, keeping a whole family mutually consistent.
package main

import "fmt"

// Two product roles that belong to the same family.
type Header interface{ Render() string }
type Footer interface{ Render() string }

type lightHeader struct{}

func (lightHeader) Render() string { return "light header" }

type lightFooter struct{}

func (lightFooter) Render() string { return "light footer" }

type darkHeader struct{}

func (darkHeader) Render() string { return "dark header" }

type darkFooter struct{}

func (darkFooter) Render() string { return "dark footer" }

// ThemeFactory produces a coherent family of widgets.
type ThemeFactory interface {
	NewHeader() Header
	NewFooter() Footer
}

type lightTheme struct{}

func (lightTheme) NewHeader() Header { return lightHeader{} }
func (lightTheme) NewFooter() Footer { return lightFooter{} }

type darkTheme struct{}

func (darkTheme) NewHeader() Header { return darkHeader{} }
func (darkTheme) NewFooter() Footer { return darkFooter{} }

func assemble(f ThemeFactory) {
	fmt.Println(f.NewHeader().Render(), "/", f.NewFooter().Render())
}

func main() {
	assemble(lightTheme{})
	assemble(darkTheme{})
}
