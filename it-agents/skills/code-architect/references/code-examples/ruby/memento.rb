# frozen_string_literal: true

# Memento — capture and restore an object's state without breaking encapsulation.

# Memento: opaque snapshot. Originator controls what it contains.
class Memento
  def initialize(state) = @state = state
  protected attr_reader :state # only the originator reads it back
end

# Originator creates and restores snapshots of its private state.
class Editor
  def initialize = @content = ""

  def type(text)
    @content += text
    self
  end

  def content = @content

  def save = Memento.new(@content.dup)

  def restore(memento)
    @content = memento.send(:state).dup
    self
  end
end

# Caretaker keeps mementos without inspecting their contents.
class History
  def initialize = @stack = []
  def push(memento) = @stack.push(memento)
  def pop = @stack.pop
end

if __FILE__ == $PROGRAM_NAME
  editor = Editor.new
  history = History.new

  editor.type("hello ")
  history.push(editor.save)
  editor.type("world")

  puts "before undo: #{editor.content.inspect}"
  editor.restore(history.pop)
  puts "after undo:  #{editor.content.inspect}"
end
