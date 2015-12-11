require 'rubygems'
require 'redis'
require 'json'

module Imaginarium::MessageAdapter
  module_function

  MAIN_CHANNEL = 'broadcast'

  def start(tubesock, auth_token)
    Imaginarium::SocketsStore.record(tubesock, auth_token)
    @redis_sub, @redis_pub = redis_instance, redis_instance
    subscribe_to_channel(MAIN_CHANNEL)
  end

  def subscribe_to_channel(channel)
    @redis_channel = channel
    @socket_logger.redis_channel = @redis_channel
    Thread.new do
      @redis_sub.subscribe(@redis_channel) do |on|
        on.message do |_, msg|
          send_to_client msg
        end
      end
    end

   # send_to_client("you have been subscribed to #{@redis_channel}")
  end

  def send_to_clients(data, auth_tokens = [])
    Imaginarium::SocketsStore.extract(auth_tokens).each{|s| s.send_data(data)}
    socket_logger.response(data)
  end

  def send_to_channel(data)
    @redis_pub.publish(@redis_channel, data)
    socket_logger.request(data)
  end

  def route(socket, data)

  end

  def socket_logger
    @socket_logger ||= SocketLogger.new(MAIN_CHANNEL)
  end

  def redis_instance
    Redis.new(url: ENV["REDIS_URL"], driver: :hiredis)
  end
end

