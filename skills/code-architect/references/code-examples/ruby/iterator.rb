# frozen_string_literal: true

# Iterator — traverse a collection without exposing its representation.

# A collection that stores items in reverse internally,
# yet offers iterators that hide that detail.
class Playlist
  include Enumerable

  def initialize = @tracks = []

  def add(track)
    @tracks.unshift(track) # stored newest-first internally
    self
  end

  # External iterator object: explicit #next / #has_next?.
  class Cursor
    def initialize(items) = (@items = items; @index = @items.length - 1)
    def has_next? = @index >= 0

    def next
      item = @items[@index]
      @index -= 1
      item
    end
  end

  def cursor = Cursor.new(@tracks)

  # Internal iterator: drives Enumerable in insertion order.
  def each
    @tracks.reverse_each { |t| yield t }
  end
end

if __FILE__ == $PROGRAM_NAME
  list = Playlist.new.add("a").add("b").add("c")

  print "internal: "
  list.each { |t| print "#{t} " }
  puts

  print "external: "
  cur = list.cursor
  print "#{cur.next} " while cur.has_next?
  puts

  puts "via Enumerable#map: #{list.map(&:upcase).inspect}"
end
