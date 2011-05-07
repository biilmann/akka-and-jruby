Using the Akka Actor Framework from JRuby
=========================================

These 3 examples demonstrate how to use the [Akka](http://akka.io/) actor framework from JRuby.

1. Spawning a simple actor and sending it messages
2. Spawning several thread based actors and fetching urls
3. Spawning actors that will consume messages from a rabbitmq server and fetch urls

To run the last example you must have a local rabbitmq server running. Use the enqueue-urls.rb script to send messages to the actors.