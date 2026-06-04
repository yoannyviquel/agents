// Proxy: stand in for a real object to control access, here adding lazy
// initialisation and result caching.
package main

import "fmt"

// Service is the interface shared by the real object and its proxy.
type Service interface {
	Fetch(key string) string
}

// realService is expensive to build and to call.
type realService struct{}

func (realService) Fetch(key string) string {
	return "value-of-" + key
}

// cachingProxy defers creation and remembers prior answers.
type cachingProxy struct {
	real  *realService
	cache map[string]string
}

func newProxy() *cachingProxy {
	return &cachingProxy{cache: make(map[string]string)}
}

func (p *cachingProxy) Fetch(key string) string {
	if v, ok := p.cache[key]; ok {
		return v + " (cached)"
	}
	if p.real == nil {
		p.real = &realService{} // lazy init on first real call
	}
	v := p.real.Fetch(key)
	p.cache[key] = v
	return v
}

func main() {
	var s Service = newProxy()
	fmt.Println(s.Fetch("a"))
	fmt.Println(s.Fetch("a"))
}
