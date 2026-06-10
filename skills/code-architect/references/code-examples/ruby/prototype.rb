# frozen_string_literal: true

# Prototype — copy existing objects via a clone method.

# Prototype role: knows how to produce a deep, independent copy of itself.
class Shape
  attr_accessor :origin, :tags

  def initialize(origin:, tags: [])
    @origin = origin   # mutable [x, y]
    @tags = tags       # mutable list
  end

  # Custom deep copy so clones don't share mutable internals.
  def initialize_copy(_source)
    super
    @origin = @origin.dup
    @tags = @tags.dup
  end

  def to_s = "#{self.class.name}(origin=#{@origin.inspect}, tags=#{@tags.inspect})"
end

class Circle < Shape
  attr_accessor :radius

  def initialize(origin:, radius:, tags: [])
    super(origin: origin, tags: tags)
    @radius = radius
  end

  def to_s = "Circle(origin=#{@origin.inspect}, r=#{@radius}, tags=#{@tags.inspect})"
end

if __FILE__ == $PROGRAM_NAME
  original = Circle.new(origin: [0, 0], radius: 5, tags: ["base"])
  copy = original.clone

  copy.origin[0] = 99
  copy.tags << "variant"
  copy.radius = 10

  puts "original: #{original}"
  puts "copy:     #{copy}"
end
