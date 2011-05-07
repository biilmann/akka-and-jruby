# Small script to enqueue messages for example-3.rb

require 'bunny'

bunch_of_urls = [
  "http://www.webpop.com", "http://www.engineyard.com/", "http://www.jruby.org/", "http://akka.io/",
  "http://www.madinspain.com", "http://www.domestika.org", "http://www.google.com", "Bad Url"
]

bunny = Bunny.new
bunny.start
queue = bunny.queue('fetch.url')

50.times do
  queue.publish bunch_of_urls[rand(bunch_of_urls.length)]
end