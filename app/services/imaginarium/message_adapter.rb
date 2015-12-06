require 'rubygems'
require 'redis'
require 'json'

module Imaginarium::MessageAdapter
  module_function

  def start_socket_listen(env)
    hijack(env) do |tubesock|
      #on connect with server
      tubesock.onopen do
        prepare_connection(tubesock)
      end
      #on message by user
      tubesock.onmessage do |data|
        send_to_channel(data)
      end
    end
  end

  def prepare_connection(tubesock)
    @socket = tubesock
    @socket_logger = SocketLogger.new(@redis_channel)
    @redis_sub, @redis_pub = redis_instance, redis_instance
  end

  def subscribe_to_channel(channel)
    return unless @socket
    @redis_channel = channel
    @socket_logger.redis_channel = @redis_channel
    Thread.new do
      @redis_sub.subscribe(@redis_channel) do |on|
        on.message do |_, msg|
          send_to_client msg
        end
      end
    end

    send_to_client("you have been subscribed to #{@redis_channel}")
  end

  def send_to_client(data)
    return unless @socket
    @socket.send_data(data)
    @socket_logger.response(data)
  end

  def send_to_channel(data)
    return unless @socket
    @redis_pub.publish(@redis_channel, data)
    @socket_logger.request(data)
  end

  def hijack(env)
    sock = Tubesock.hijack(env)
    yield sock
    sock.onclose do
      ActiveRecord::Base.clear_active_connections! if defined? ActiveRecord
    end
    sock.listen
  end

  def redis_instance
    Redis.new(url: ENV["REDIS_URL"], driver: :hiredis)
  end
end

