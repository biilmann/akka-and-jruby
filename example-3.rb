$: << 'vendor/akka'

require 'java'
require 'akka-modules-1.0'
require 'net/http'

module Akka
  include_package 'akka.actor'
  include_package 'akka.amqp'
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
    url = String.from_java_bytes(msg.payload)
    puts "Downloaded #{Net::HTTP.get(URI.parse(url)).length} bytes from #{url}"
  end
end

connection = Akka::AMQP.newConnection(Akka::AMQP::ConnectionParameters.new)

10.times do
  params = Akka::AMQP::ConsumerParameters.new(
    "fetch.url", Actor.spawn, "fetch.url", Akka::AMQP::ActiveDeclaration.new(false, false), true, Akka::AMQP::ChannelParameters.new
  )
  consumer = Akka::AMQP.newConsumer(connection, params)
end