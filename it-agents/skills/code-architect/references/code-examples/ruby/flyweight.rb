# frozen_string_literal: true

# Flyweight — share intrinsic state across many objects to save memory.

# Flyweight holds only intrinsic (shared, immutable) state.
class GlyphStyle
  attr_reader :font, :size, :color

  def initialize(font, size, color)
    @font = font
    @size = size
    @color = color
  end

  # Extrinsic state (position) is passed in at use time, not stored.
  def stamp(char, at:)
    "'#{char}'@#{at} {#{@font}/#{@size}/#{@color}}"
  end
end

# Factory caches and reuses flyweights by their intrinsic key.
class StyleFactory
  def initialize = @pool = {}

  def fetch(font, size, color)
    key = [font, size, color]
    @pool[key] ||= GlyphStyle.new(font, size, color)
  end

  def distinct_count = @pool.size
end

if __FILE__ == $PROGRAM_NAME
  factory = StyleFactory.new
  text = "aaab"

  text.chars.each_with_index do |char, i|
    style = factory.fetch("mono", 12, "black")
    puts style.stamp(char, at: i)
  end

  puts "characters drawn: #{text.length}"
  puts "shared flyweights: #{factory.distinct_count}"
end
