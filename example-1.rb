$: << 'vendor/akka'

require 'java'
require 'akka-modules-1.0'

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
  
  def onReceive(msg)
    puts "Got message: #{msg}"
  end
end

actor = Actor.spawn

10.times do
  actor.sendOneWay("Hello Actor!")
end