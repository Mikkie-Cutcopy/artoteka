require 'rubygems'
require 'redis'
require 'json'

class Connection::MessageAdapter
  include RedisMethods
  attr_reader :socket, :redis_channel
  attr_accessor :redis_token

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
        on.message do |channel, msg|
          redis_channel_filter(channel, msg)
        end
      end
    end
  end

  def hundle(msg)
    data = JSON.parse(msg)
    data.merge!('adapter' => self)
    response = Connection::MessageProtocol::Request.new(data).call
    send_to_client(response.to_json)
  end

  def send_to_client(data)
    @socket.send_data(data)
    socket_logger.response(data)
  end

  def send_to_channel(data)
    if @redis_token
      data.merge!('from' => @redis_token)
      redis_pub.publish(@redis_channel, data.to_json)
      socket_logger.request(data)
    end
  end

  def redis_channel_filter(channel, msg)
    data = JSON.parse(msg)
    if channel == 'broadcast' || channel == @redis_channel || data['recipients'].include?(@redis_token)
      send_to_client msg
    end
  end

  def socket_logger
    @socket_logger ||= SocketLogger.new(MAIN_CHANNEL)
  end

end

