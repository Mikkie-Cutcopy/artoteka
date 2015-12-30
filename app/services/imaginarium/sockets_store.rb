module Imaginarium::SocketsStore

  LIMIT = 10000

  class SocketObject
    attr_reader :socket, :auth_token
    def initialize(socket)
      @socket = socket
    end
  end

  def record(socket)
    active << SocketObject.new(socket) if count < LIMIT
  end

  def active
    @active ||= []
  end

  def extract(tokens)
    measure_time do
      active.select{|object| tokens.include?(object.auth_token)}
    end
  end

  def kill(socket)
    measure_time do
      active.each{|object| object.delete if object.socket == socket}
    end
  end

  def count
    active.count
  end

  def measure_time
    beginning_time = Time.now
    response = yield
    end_time = Time.now
    @last_measure_time = (end_time - beginning_time)*1000
    response
  end

  def last_measure_time
    @last_measure_time
  end

end