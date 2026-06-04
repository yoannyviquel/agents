# frozen_string_literal: true

# Decorator — attach responsibilities by wrapping objects at runtime.

# Core component.
class PlainMessage
  def initialize(text) = @text = text
  def render = @text
end

# Base decorator forwards to the wrapped component.
class MessageDecorator
  def initialize(component) = @component = component
  def render = @component.render
end

# Concrete decorators add behavior around the wrapped result.
class Uppercase < MessageDecorator
  def render = @component.render.upcase
end

class Exclaim < MessageDecorator
  def render = "#{@component.render}!"
end

class Bracketed < MessageDecorator
  def render = "[#{@component.render}]"
end

if __FILE__ == $PROGRAM_NAME
  base = PlainMessage.new("hello")
  puts base.render

  # Decorators stack in any order, each wrapping the previous.
  decorated = Bracketed.new(Exclaim.new(Uppercase.new(base)))
  puts decorated.render
end
