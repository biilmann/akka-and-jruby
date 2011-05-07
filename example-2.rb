$: << 'vendor/akka'

require 'java'
require 'akka-modules-1.0'
require 'net/http'

module Akka
  include_package 'akka.actor'
  include_package 'akka.dispatch'
end

class Actor < Akka::UntypedActor
  def self.spawn
    Akka::Actors.actorOf { new }.tap do |actor|
      actor.setDispatcher(Akka::Dispatchers.newThreadBasedDispatcher(actor))
      actor.start
    end
  end
  
  def onReceive(url)
    puts "Downloaded #{Net::HTTP.get(URI.parse(url)).length} bytes from #{url}"
  end
end

actors = (0..4).map { Actor.spawn }

puts "Starting HTTP requests"

["http://www.webpop.com", "http://www.engineyard.com/", "http://www.jruby.org/", "http://akka.io/"].each_with_index do |url, i|
  actors[i].sendOneWay(url)
end