# frozen_string_literal: true

# Bridge — split abstraction and implementation into independent hierarchies.

# Implementation hierarchy: how output is physically emitted.
class ConsoleSink
  def emit(line) = "console> #{line}"
end

class FileSink
  def initialize(path) = @path = path
  def emit(line) = "#{@path}: #{line}"
end

# Abstraction hierarchy: what is logged, holding a reference to an implementation.
class Logger
  def initialize(sink) = @sink = sink

  def log(message) = @sink.emit(message)
end

# Refined abstraction extends behavior without touching sinks.
class TimestampLogger < Logger
  def log(message) = super("[#{stamp}] #{message}")

  private

  def stamp = "T+0"
end

if __FILE__ == $PROGRAM_NAME
  puts Logger.new(ConsoleSink.new).log("plain")
  puts TimestampLogger.new(ConsoleSink.new).log("with time")
  puts TimestampLogger.new(FileSink.new("/var/log/app")).log("to file")
end
