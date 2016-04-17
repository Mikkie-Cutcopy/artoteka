require 'redis'
require 'json'
require 'connection/message_adapter'


class ConnectionController < ApplicationController
  include Tubesock::Hijack
  def socket_listen
      message_adapter = Connection::MessageAdapter.new
      hijack do |tubesock|
        #on connect with server
        tubesock.onopen do
          message_adapter.start(tubesock)
        end

        tubesock.onclose do
          #Imaginarium::SocketsStore.kill(tubesock)
        end
        #on message by user
        tubesock.onmessage do |data|
          message_adapter.hundle(data)
        end
      end
  end
end
