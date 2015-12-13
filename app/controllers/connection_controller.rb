require 'redis'
require 'json'
require 'imaginarium/message_adapter'


class ConnectionController < ApplicationController
  include Tubesock::Hijack
  def socket_listen
      hijack do |tubesock|
        #on connect with server
        tubesock.onopen do
          Imaginarium::MessageAdapter.start(tubesock)
        end

        tubesock.onclose do
          Imaginarium::SocketsStore.kill(tubesock)
        end
        #on message by user
        tubesock.onmessage do |data|
          Imaginarium::MessageAdapter.hundle(tubesock, data)
          #Imaginarium::MessageAdapter.send_to_channel(data)
        end
      end
  end
end
