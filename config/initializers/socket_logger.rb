class SocketLogger < Logger
  attr_accessor :redis_channel

  def initialize(redis_channel)
    self.redis_channel = redis_channel
    super(STDOUT)
  end

  def request(data)
    info("SOCKET REQUEST: channel ##{redis_channel}, message: #{data}")
  end

  def response(data)
    info("SOCKET RESPONSE: channel ##{redis_channel}, message: #{data}")
  end

  def socket_info
    info("SOCKET RESPONSE: channel ##{redis_channel}, message: #{data}")
  end
end