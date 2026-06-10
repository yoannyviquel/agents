# frozen_string_literal: true

# Template Method — algorithm skeleton in a base class with overridable steps.

# Base class fixes the algorithm order; subclasses fill in the steps.
class ImportPipeline
  # Template method: the invariant skeleton.
  def run(source)
    raw = read(source)
    rows = parse(raw)
    rows = filter(rows) # hook with a default
    store(rows)
  end

  private

  def read(_source) = raise NotImplementedError
  def parse(_raw) = raise NotImplementedError

  # Hook: optional override, sensible default.
  def filter(rows) = rows

  def store(rows) = "stored #{rows.size} rows: #{rows.inspect}"
end

class CsvImport < ImportPipeline
  private

  def read(source) = source
  def parse(raw) = raw.split("\n").map { |l| l.split(",") }
  def filter(rows) = rows.reject { |r| r.first.start_with?("#") }
end

if __FILE__ == $PROGRAM_NAME
  csv = "a,1\n#skip,2\nb,3"
  puts CsvImport.new.run(csv)
end
