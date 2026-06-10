# frozen_string_literal: true

# Strategy — a family of interchangeable algorithms behind one interface.

# Strategies: each exposes #apply(items) and can be swapped freely.
class AscendingOrder
  def apply(items) = items.sort
end

class DescendingOrder
  def apply(items) = items.sort.reverse
end

# A lambda is a perfectly valid strategy too (duck typing).
ByLength = ->(items) { items.sort_by(&:length) }

# Context holds a strategy and delegates the varying step to it.
class Sorter
  def initialize(strategy) = @strategy = strategy
  attr_writer :strategy

  def run(items)
    @strategy.respond_to?(:apply) ? @strategy.apply(items) : @strategy.call(items)
  end
end

if __FILE__ == $PROGRAM_NAME
  data = %w[pear fig apple kiwi]
  sorter = Sorter.new(AscendingOrder.new)

  puts sorter.run(data).inspect

  sorter.strategy = DescendingOrder.new
  puts sorter.run(data).inspect

  sorter.strategy = ByLength
  puts sorter.run(data).inspect
end
