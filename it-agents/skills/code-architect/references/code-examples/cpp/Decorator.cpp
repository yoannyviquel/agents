// Decorator — attach responsibilities by wrapping objects at runtime.
#include <iostream>
#include <memory>
#include <string>

// Component interface.
class Stream {
public:
    virtual ~Stream() = default;
    virtual std::string write(const std::string& data) const = 0;
};

// Concrete component.
class RawStream : public Stream {
public:
    std::string write(const std::string& data) const override { return data; }
};

// Base decorator wraps another Stream.
class StreamDecorator : public Stream {
protected:
    std::unique_ptr<Stream> inner;
public:
    explicit StreamDecorator(std::unique_ptr<Stream> s) : inner(std::move(s)) {}
};

class CompressDecorator : public StreamDecorator {
public:
    using StreamDecorator::StreamDecorator;
    std::string write(const std::string& data) const override {
        return "compressed(" + inner->write(data) + ")";
    }
};

class EncryptDecorator : public StreamDecorator {
public:
    using StreamDecorator::StreamDecorator;
    std::string write(const std::string& data) const override {
        return "encrypted(" + inner->write(data) + ")";
    }
};

int main() {
    std::unique_ptr<Stream> s = std::make_unique<RawStream>();
    s = std::make_unique<CompressDecorator>(std::move(s));
    s = std::make_unique<EncryptDecorator>(std::move(s));

    std::cout << s->write("payload") << "\n";
    return 0;
}
