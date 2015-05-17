class ImagineConnection

  def initialize(socket)
    @socket = socket
  end

  def send_message(data)
    @socket.send_data(data)
  end
end