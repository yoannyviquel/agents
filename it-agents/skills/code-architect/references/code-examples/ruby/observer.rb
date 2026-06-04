# frozen_string_literal: true

# Observer — subscription mechanism to notify subscribers of events.

# Subject maintains a list of observers and broadcasts changes.
class Subject
  def initialize = @observers = []

  def subscribe(observer)
    @observers << observer
    self
  end

  def unsubscribe(observer)
    @observers.delete(observer)
    self
  end

  def notify(event)
    @observers.each { |o| o.update(event) }
  end
end

# Concrete subject pushes an event whenever its value changes.
class Thermometer < Subject
  def reading=(value)
    @reading = value
    notify(degrees: value)
  end
end

# Observers react to events; any object with #update qualifies.
class Display
  def initialize(label) = @label = label
  def update(event) = puts "#{@label}: #{event[:degrees]}°"
end

if __FILE__ == $PROGRAM_NAME
  thermo = Thermometer.new
  phone = Display.new("phone")
  panel = Display.new("panel")

  thermo.subscribe(phone).subscribe(panel)
  thermo.reading = 21

  thermo.unsubscribe(panel)
  thermo.reading = 23
end
