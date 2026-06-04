# frozen_string_literal: true

# Command — encapsulate a request as an object, support undo.

# Receiver: holds the state the commands act on.
class Counter
  attr_reader :value

  def initialize = @value = 0
  def add(n) = @value += n
  def sub(n) = @value -= n
end

# Command interface: #execute / #undo over a receiver.
class AddCommand
  def initialize(receiver, amount)
    @receiver = receiver
    @amount = amount
  end

  def execute = @receiver.add(@amount)
  def undo = @receiver.sub(@amount)
end

# Invoker runs commands and keeps a history for undo.
class Invoker
  def initialize = @history = []

  def run(command)
    command.execute
    @history.push(command)
  end

  def undo_last
    command = @history.pop
    command&.undo
  end
end

if __FILE__ == $PROGRAM_NAME
  counter = Counter.new
  invoker = Invoker.new

  invoker.run(AddCommand.new(counter, 5))
  invoker.run(AddCommand.new(counter, 3))
  puts "after two adds: #{counter.value}"

  invoker.undo_last
  puts "after undo: #{counter.value}"
end
