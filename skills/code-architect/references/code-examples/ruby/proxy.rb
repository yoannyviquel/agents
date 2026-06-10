# frozen_string_literal: true

# Proxy — a placeholder controlling access to a real object (lazy + caching here).

# Real subject: expensive to create, expensive to query.
class RemoteResource
  def initialize(name)
    @name = name
    puts "  (loaded #{name} from network)"
  end

  def fetch(key) = "#{@name}:#{key}=#{key.length}"
end

# Proxy shares the subject interface, defers creation, and caches results.
class ResourceProxy
  def initialize(name) = @name = name

  def fetch(key)
    @cache ||= {}
    @cache.fetch(key) do
      @cache[key] = subject.fetch(key)
    end
  end

  private

  def subject
    @subject ||= RemoteResource.new(@name) # lazy: built on first real use
  end
end

if __FILE__ == $PROGRAM_NAME
  proxy = ResourceProxy.new("catalog")
  puts "proxy created (nothing loaded yet)"

  puts proxy.fetch("alpha") # triggers load
  puts proxy.fetch("alpha") # served from cache, no reload
  puts proxy.fetch("beta")  # cache miss, subject already loaded
end
