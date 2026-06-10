# frozen_string_literal: true

# Visitor — separate algorithms from objects via accept/visit (double dispatch).

# Elements expose #accept and call back the type-specific visitor method.
class Literal
  attr_reader :value

  def initialize(value) = @value = value
  def accept(visitor) = visitor.visit_literal(self)
end

class Addition
  attr_reader :left, :right

  def initialize(left, right)
    @left = left
    @right = right
  end

  def accept(visitor) = visitor.visit_addition(self)
end

# A visitor implements one method per element type.
class Evaluator
  def visit_literal(node) = node.value
  def visit_addition(node) = node.left.accept(self) + node.right.accept(self)
end

class Printer
  def visit_literal(node) = node.value.to_s
  def visit_addition(node) = "(#{node.left.accept(self)} + #{node.right.accept(self)})"
end

if __FILE__ == $PROGRAM_NAME
  # (1 + (2 + 3))
  tree = Addition.new(Literal.new(1), Addition.new(Literal.new(2), Literal.new(3)))

  puts "print: #{tree.accept(Printer.new)}"
  puts "eval:  #{tree.accept(Evaluator.new)}"
end
