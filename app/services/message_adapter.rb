require 'rubygems'
require 'redis'
require 'json'

module MessageAdapter
  module_function

  attr_accessor :redis_channel

  def start(socket)
    @socket = socket
    self.redis_channel ||= 'broadcast'
    @socket_logger = SocketLogger.new(redis_channel)
    @redis_sub, @redis_pub = redis_instance, redis_instance
  end

  def subscribe_to_channel(channel)
    self.redis_channel = channel
    @socket_logger.redis_channel = redis_channel
    Thread.new do
      @redis_sub.subscribe(redis_channel) do |on|
        on.message do |_, msg|
          send_to_client msg
        end
      end
    end

    send_to_user("you have been subscribed to #{@redis_channel}")
  end

  def send_to_client(data)
    return unless @socket
    @socket.send_data(data)
    @socket_logger.response(data)
  end

  def send_to_channel(data)
    return unless @redis_pub
    @redis_pub.publish(redis_channel, data)
    @socket_logger.request(data)
  end

  private

  def redis_instance
    Redis.new(url: ENV["REDIS_URL"], driver: :hiredis)
  end
end
