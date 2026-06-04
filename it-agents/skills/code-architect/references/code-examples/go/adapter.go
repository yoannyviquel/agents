// Adapter: wrap an incompatible interface so it satisfies the interface a
// client already expects.
package main

import (
	"fmt"
	"strings"
)

// Target is what the client code depends on.
type Target interface {
	Request(payload string) string
}

// legacyService has a useful but incompatible signature.
type legacyService struct{}

func (legacyService) SpecificCall(data []byte) []byte {
	return []byte(strings.ToUpper(string(data)))
}

// adapter translates Target calls into legacyService calls.
type adapter struct {
	wrapped legacyService
}

func (a adapter) Request(payload string) string {
	out := a.wrapped.SpecificCall([]byte(payload))
	return string(out)
}

func clientCode(t Target) {
	fmt.Println(t.Request("hello"))
}

func main() {
	clientCode(adapter{wrapped: legacyService{}})
}
