# frozen_string_literal: true

# Facade — a simplified interface over a complex subsystem.

# Subsystem parts, each with its own narrow responsibility.
class Compressor
  def pack(data) = "packed(#{data})"
end

class Encryptor
  def encrypt(blob) = "enc(#{blob})"
end

class Uploader
  def send(payload, to:) = "#{payload} -> #{to}"
end

# Facade hides the orchestration behind one easy method.
class BackupFacade
  def initialize
    @compressor = Compressor.new
    @encryptor = Encryptor.new
    @uploader = Uploader.new
  end

  def backup(data, destination:)
    blob = @compressor.pack(data)
    secured = @encryptor.encrypt(blob)
    @uploader.send(secured, to: destination)
  end
end

if __FILE__ == $PROGRAM_NAME
  puts BackupFacade.new.backup("report.csv", destination: "s3://bucket")
end
