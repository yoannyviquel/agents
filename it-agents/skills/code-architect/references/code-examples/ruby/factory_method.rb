# frozen_string_literal: true

# Factory Method — subclasses decide which product class to instantiate via a factory method.

# Product role: anything that can render itself.
class TextExport
  def serialize(payload) = "TEXT|#{payload}"
end

class JsonExport
  def serialize(payload) = %({"value":"#{payload}"})
end

# Creator declares the factory method and uses the product it returns.
class Reporter
  # Factory method — overridden by subclasses.
  def build_formatter
    raise NotImplementedError, "#{self.class} must define #build_formatter"
  end

  def report(payload)
    formatter = build_formatter
    "[#{self.class.name}] #{formatter.serialize(payload)}"
  end
end

class TextReporter < Reporter
  def build_formatter = TextExport.new
end

class JsonReporter < Reporter
  def build_formatter = JsonExport.new
end

if __FILE__ == $PROGRAM_NAME
  [TextReporter.new, JsonReporter.new].each do |reporter|
    puts reporter.report("hello")
  end
end
