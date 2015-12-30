require 'rubygems'
require 'redis'
require 'json'

class Imaginarium::MessageAdapter
  attr_reader :socket, :socket_logger, :redis_channel

  MAIN_CHANNEL = 'broadcast'

  def start(socket)
    @socket = socket
    subscribe_to_channel(MAIN_CHANNEL)
  end

  def subscribe_to_channel(channel)
    @redis_channel = channel
    socket_logger.redis_channel = @redis_channel
    Thread.new do
      redis_sub.subscribe(@redis_channel) do |on|
        on.message do |_, msg|
          send_to_client msg
        end
      end
    end
  end

  def hundle(data)
    response = MessageProtocol::Request.new(data).call
    send_to_client(response)
  end

  def send_to_client(data)
    @socket.send_data(data)
    socket_logger.response(data)
  end

  def send_to_channel(data)
    redis_pub.publish(@redis_channel, data)
    socket_logger.request(data)
  end

  def socket_logger
    @socket_logger ||= SocketLogger.new(MAIN_CHANNEL)
  end

  def redis_pub
    @redis_pub ||= redis_instance
  end

  def redis_sub
    @redis_sub ||= redis_instance
  end

  def redis_instance
    Redis.new(url: ENV["REDIS_URL"], driver: :hiredis)
  end
end

