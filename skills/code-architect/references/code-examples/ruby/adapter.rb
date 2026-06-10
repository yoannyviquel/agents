# frozen_string_literal: true

# Adapter — make an incompatible interface usable via a wrapper.

# Target interface the client expects: #area.
class Client
  def describe(shape) = "area = #{format('%.2f', shape.area)}"
end

# Adaptee with an incompatible API (returns dimensions, no #area).
class LegacyRectangle
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
  end
end

# Adapter wraps the adaptee and exposes the target interface.
class RectangleAdapter
  def initialize(legacy) = @legacy = legacy

  def area = @legacy.width * @legacy.height
end

# A native shape already conforming to the target.
class Disc
  def initialize(radius) = @radius = radius
  def area = Math::PI * @radius**2
end

if __FILE__ == $PROGRAM_NAME
  client = Client.new
  legacy = LegacyRectangle.new(3, 4)

  puts client.describe(RectangleAdapter.new(legacy))
  puts client.describe(Disc.new(2))
end
