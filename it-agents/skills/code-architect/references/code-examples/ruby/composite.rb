# frozen_string_literal: true

# Composite — compose objects into trees, treat leaf and container uniformly.

# Leaf: a single item with a weight.
class Item
  def initialize(name, weight)
    @name = name
    @weight = weight
  end

  def total_weight = @weight

  def render(indent = 0) = "#{'  ' * indent}- #{@name} (#{@weight})"
end

# Composite: holds children and exposes the same interface as a leaf.
class Box
  def initialize(name)
    @name = name
    @children = []
  end

  def add(component)
    @children << component
    self
  end

  def total_weight = @children.sum(&:total_weight)

  def render(indent = 0)
    [
      "#{'  ' * indent}+ #{@name} (#{total_weight})",
      *@children.map { |c| c.render(indent + 1) }
    ].join("\n")
  end
end

if __FILE__ == $PROGRAM_NAME
  tree = Box.new("crate")
            .add(Item.new("book", 2))
            .add(Box.new("pouch")
                   .add(Item.new("pen", 1))
                   .add(Item.new("eraser", 1)))
  puts tree.render
  puts "grand total = #{tree.total_weight}"
end
