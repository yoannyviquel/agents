# frozen_string_literal: true

# Singleton — ensure one instance with a global access point.

# Hand-rolled singleton (rather than `require "singleton"`) to show the mechanics.
class Registry
  @mutex = Mutex.new

  class << self
    def instance
      return @instance if @instance

      @mutex.synchronize { @instance ||= new }
    end

    private :new
  end

  def initialize
    @store = {}
  end

  def set(key, value)
    @store[key] = value
    self
  end

  def get(key) = @store[key]

  def keys = @store.keys
end

if __FILE__ == $PROGRAM_NAME
  Registry.instance.set(:env, "prod")
  Registry.instance.set(:region, "eu")

  puts "same object? #{Registry.instance.equal?(Registry.instance)}"
  puts "env = #{Registry.instance.get(:env)}"
  puts "keys = #{Registry.instance.keys.inspect}"

  begin
    Registry.new
  rescue NoMethodError => e
    puts "direct new blocked: #{e.message.split("'").first.strip}"
  end
end
