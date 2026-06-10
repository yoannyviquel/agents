# frozen_string_literal: true

# State — let an object alter behavior when its state changes (state objects).

# Context delegates behavior to its current state object.
class Door
  attr_accessor :state

  def initialize = @state = ClosedState.new
  def push = @state.push(self)
  def pull = @state.pull(self)
  def label = @state.name
end

# Each state encapsulates behavior and the transitions it allows.
class ClosedState
  def name = "closed"
  def push(door) = door.state = OpenState.new
  def pull(_door) = nil # already closed
end

class OpenState
  def name = "open"
  def push(_door) = nil # already open
  def pull(door) = door.state = ClosedState.new
end

if __FILE__ == $PROGRAM_NAME
  door = Door.new
  puts door.label   # closed
  door.push
  puts door.label   # open
  door.push         # no-op, still open
  puts door.label
  door.pull
  puts door.label   # closed
end
