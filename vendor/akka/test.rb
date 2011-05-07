require 'java'
require 'akka-modules-1.0'

module Akka
  include_package 'akka.actor'
  include_package 'akka.amqp'
end

module Akka
  include_package 'akka.actor'
  include_package 'akka.amqp'
end

module Actors
  class BlockActor < Akka::UntypedActor
    def self.spawn(&block)
      Akka::Actors.actorOf(self).tap do |actor|
        actor.instance_variable_set(:@_block, block)
        actor.start
      end
    end
    
    def self.create(*args)
      new(*args)
    end
    
    def onReceive(msg)
      puts "Calling block with message #{msg}"
      @block.call(msg)
    end
  end
end

actor = Actors::BlockActor.spawn do |msg|
  puts "Helooo from block: #{msg}"
end

connection = Akka::AMQP.newConnection #(Akka::AMQP::ConnectionParameters.new("127.0.0.1", 5672, "guest", "guest", "/"))

exchangeParameters = Akka::AMQP::ExchangeParameters.new("my.exchange", Akka::Direct.getInstance());
# 
# consumerParameters = Akka::AMQP::ConsumerParameters.new("my.test", actor, exchangeParameters)
handler = Actors::BlockActor.spawn do |msg|
  puts "Hello #{msg}"
end

params = Akka::AMQP::ConsumerParameters.new("my.queue", handler, "my.queue", Akka::AMQP::ActiveDeclaration.new, true, Akka::AMQP::ChannelParameters.new)
consumer = Akka::AMQP.newConsumer(connection, params)

# consumer = Akka::AMQP.newConsumer(connection, consumerParameters)

5.times do
  puts "Sending message"
  producer = Akka::AMQP.newProducer(connection, Akka::AMQP::ProducerParameters.new(exchangeParameters))
  producer.sendOneWay(Akka::Message.new("Actor".to_java_bytes, "my.queue"))
  sleep 1
end
