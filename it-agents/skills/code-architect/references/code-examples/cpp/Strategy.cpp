// Strategy — a family of interchangeable algorithms behind one interface.
#include <iostream>
#include <memory>
#include <numeric>
#include <vector>

// Strategy interface.
class Reducer {
public:
    virtual ~Reducer() = default;
    virtual int combine(const std::vector<int>& data) const = 0;
};

class SumReducer : public Reducer {
public:
    int combine(const std::vector<int>& data) const override {
        return std::accumulate(data.begin(), data.end(), 0);
    }
};

class MaxReducer : public Reducer {
public:
    int combine(const std::vector<int>& data) const override {
        int best = data.front();
        for (int v : data) best = v > best ? v : best;
        return best;
    }
};

// Context delegates to the chosen strategy.
class Pipeline {
    std::unique_ptr<Reducer> reducer;
public:
    void setStrategy(std::unique_ptr<Reducer> r) { reducer = std::move(r); }
    int run(const std::vector<int>& data) const { return reducer->combine(data); }
};

int main() {
    std::vector<int> data{3, 7, 1, 9, 4};
    Pipeline pipeline;

    pipeline.setStrategy(std::make_unique<SumReducer>());
    std::cout << "sum = " << pipeline.run(data) << "\n";

    pipeline.setStrategy(std::make_unique<MaxReducer>());
    std::cout << "max = " << pipeline.run(data) << "\n";
    return 0;
}
