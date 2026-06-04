// Iterator — traverse a collection without exposing its representation.
#include <iostream>
#include <memory>
#include <string>
#include <vector>

template <typename T>
class Iterator {
public:
    virtual ~Iterator() = default;
    virtual bool hasNext() const = 0;
    virtual const T& next() = 0;
};

template <typename T>
class Collection {
public:
    virtual ~Collection() = default;
    virtual std::unique_ptr<Iterator<T>> createIterator() const = 0;
};

// Ring buffer with a custom traversal order, hidden from the client.
class Ring : public Collection<std::string> {
    std::vector<std::string> items;
    size_t start;
public:
    explicit Ring(size_t startIndex) : start(startIndex) {}
    void add(const std::string& v) { items.push_back(v); }
    const std::vector<std::string>& raw() const { return items; }
    size_t startIndex() const { return start; }

    std::unique_ptr<Iterator<std::string>> createIterator() const override;
};

class RingIterator : public Iterator<std::string> {
    const Ring& ring;
    size_t step = 0;
public:
    explicit RingIterator(const Ring& r) : ring(r) {}
    bool hasNext() const override { return step < ring.raw().size(); }
    const std::string& next() override {
        size_t idx = (ring.startIndex() + step) % ring.raw().size();
        ++step;
        return ring.raw()[idx];
    }
};

std::unique_ptr<Iterator<std::string>> Ring::createIterator() const {
    return std::make_unique<RingIterator>(*this);
}

int main() {
    Ring ring{2};
    ring.add("a"); ring.add("b"); ring.add("c"); ring.add("d");
    auto it = ring.createIterator();
    while (it->hasNext()) std::cout << it->next() << " ";
    std::cout << "\n";
    return 0;
}
