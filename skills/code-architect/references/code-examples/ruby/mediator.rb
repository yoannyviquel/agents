# frozen_string_literal: true

# Mediator — centralize communication between components.

# Mediator coordinates colleagues so they don't reference each other directly.
class ChatRoom
  def initialize = @members = {}

  def join(participant)
    @members[participant.name] = participant
    participant.room = self
  end

  # Colleagues talk through the mediator only.
  def relay(from:, text:)
    @members.each_value do |member|
      member.receive(from: from, text: text) unless member.name == from
    end
  end
end

# Colleague knows the mediator but not its peers.
class Participant
  attr_reader :name
  attr_accessor :room

  def initialize(name) = @name = name

  def send(text)
    room.relay(from: @name, text: text)
  end

  def receive(from:, text:)
    puts "#{@name} got from #{from}: #{text}"
  end
end

if __FILE__ == $PROGRAM_NAME
  room = ChatRoom.new
  ana = Participant.new("ana")
  ben = Participant.new("ben")
  cid = Participant.new("cid")
  [ana, ben, cid].each { |p| room.join(p) }

  ana.send("hi all")
end
