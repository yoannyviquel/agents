# frozen_string_literal: true

# Chain of Responsibility — pass a request along a chain of handlers.

# Base handler keeps a successor and forwards what it can't handle.
class Handler
  def initialize = @successor = nil

  def chain(next_handler)
    @successor = next_handler
    next_handler # return for fluent linking
  end

  def handle(request)
    @successor ? @successor.handle(request) : "unhandled: #{request.inspect}"
  end
end

# Each concrete handler either processes the request or passes it on.
class AuthHandler < Handler
  def handle(request)
    return "rejected: not authenticated" unless request[:user]

    super
  end
end

class RateLimitHandler < Handler
  def handle(request)
    return "rejected: rate limited" if request[:hits].to_i > 100

    super
  end
end

class ServeHandler < Handler
  def handle(request) = "served #{request[:path]} for #{request[:user]}"
end

if __FILE__ == $PROGRAM_NAME
  pipeline = AuthHandler.new
  pipeline.chain(RateLimitHandler.new).chain(ServeHandler.new)

  puts pipeline.handle(path: "/home", user: nil, hits: 1)
  puts pipeline.handle(path: "/home", user: "ana", hits: 500)
  puts pipeline.handle(path: "/home", user: "ana", hits: 3)
end
