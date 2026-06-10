# frozen_string_literal: true

# Builder — construct complex objects step by step.

Document = Struct.new(:title, :sections, :footer) do
  def to_s
    out = ["# #{title}"]
    out.concat(sections.map { |s| "- #{s}" })
    out << "(#{footer})" if footer
    out.join("\n")
  end
end

# Builder exposes fluent steps and assembles the final product.
class DocumentBuilder
  def initialize
    @title = "Untitled"
    @sections = []
    @footer = nil
  end

  def titled(text)
    @title = text
    self
  end

  def add_section(text)
    @sections << text
    self
  end

  def with_footer(text)
    @footer = text
    self
  end

  def build = Document.new(@title, @sections, @footer)
end

# Optional director encapsulates a reusable construction recipe.
class Director
  def minimal(builder) = builder.titled("Quick Note").add_section("body").build
end

if __FILE__ == $PROGRAM_NAME
  doc = DocumentBuilder.new
        .titled("Release Notes")
        .add_section("Added builder demo")
        .add_section("Fixed typos")
        .with_footer("v1.0")
        .build
  puts doc
  puts "---"
  puts Director.new.minimal(DocumentBuilder.new)
end
