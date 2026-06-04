// Proxy — a stand-in that controls access to a real object, here adding lazy
// initialization and caching while sharing the subject's interface.

use std::cell::RefCell;

trait Resource {
    fn fetch(&self, key: &str) -> String;
}

// The real, expensive subject.
struct RemoteResource;

impl Resource for RemoteResource {
    fn fetch(&self, key: &str) -> String {
        println!("RemoteResource: expensive fetch for '{}'", key);
        format!("payload-of-{}", key)
    }
}

// Proxy delays creating the real subject and caches results.
struct CachingProxy {
    real: RefCell<Option<RemoteResource>>,
    cache: RefCell<Vec<(String, String)>>,
}

impl CachingProxy {
    fn new() -> Self {
        CachingProxy { real: RefCell::new(None), cache: RefCell::new(Vec::new()) }
    }
}

impl Resource for CachingProxy {
    fn fetch(&self, key: &str) -> String {
        if let Some((_, v)) = self.cache.borrow().iter().find(|(k, _)| k == key) {
            println!("CachingProxy: cache hit for '{}'", key);
            return v.clone();
        }
        if self.real.borrow().is_none() {
            *self.real.borrow_mut() = Some(RemoteResource);
        }
        let value = self.real.borrow().as_ref().unwrap().fetch(key);
        self.cache.borrow_mut().push((key.to_string(), value.clone()));
        value
    }
}

fn main() {
    let proxy = CachingProxy::new();
    println!("=> {}", proxy.fetch("a"));
    println!("=> {}", proxy.fetch("a"));
    println!("=> {}", proxy.fetch("b"));
}
