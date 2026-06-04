# frozen_string_literal: true

# Abstract Factory — create families of related objects without specifying concrete classes.

# Product families: a "header" and a "field" that must visually match.

class LightHeader
  def render = "=== light header ==="
end

class LightField
  def render(name) = "[ #{name} ]"
end

class DarkHeader
  def render = "*** dark header ***"
end

class DarkField
  def render(name) = "< #{name} >"
end

# Abstract factory contract: build_header + build_field.
class LightKit
  def build_header = LightHeader.new
  def build_field  = LightField.new
end

class DarkKit
  def build_header = DarkHeader.new
  def build_field  = DarkField.new
end

# Client works only against the factory and product roles.
class Form
  def initialize(kit) = @kit = kit

  def draw(fields)
    lines = [@kit.build_header.render]
    field = @kit.build_field
    fields.each { |name| lines << field.render(name) }
    lines.join("\n")
  end
end

if __FILE__ == $PROGRAM_NAME
  [LightKit.new, DarkKit.new].each do |kit|
    puts Form.new(kit).draw(%w[name email])
    puts
  end
end
