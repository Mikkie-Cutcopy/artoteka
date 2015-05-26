require 'rubygems'
require 'redis'
require 'json'

module MessageAdapter
  module_function

  attr_reader :channel

  def start(socket)
    @socket = socket
    @channel ||= 'broadcast'
    @redis_sub, @redis_pub = Array.new(2).map do
        Redis.new(url: ENV["REDIS_URL"], driver: :hiredis)
    end
  end

  def subscribe_to_channel(channel)
    @channel = channel
    @redis_listener = Thread.new do
                        @redis_sub.subscribe(@channel) do |on|
                          on.message do |redis_channel, msg|
                            send_to_user "##{redis_channel} -  #{msg}"
                          end
                        end
    end

    send_to_user("you have been subscribed to #{@channel}")
  end

  def send_to_user(data)
    @socket.send_data(data)
  end

  def send_to_channel(data)
    @redis_pub.publish @channel, data
  end
end
