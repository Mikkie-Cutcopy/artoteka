require 'redis'
require 'json'
require 'imaginarium/message_adapter'


class MessageController < ApplicationController
  include Tubesock::Hijack

  def message
    hijack do |tubesock|
      #on connect with server
      tubesock.onopen do
        Imaginarium::MessageAdapter.start(tubesock)
      end

      tubesock.onclose do

      end

      #on message by user
      tubesock.onmessage do |data|
        Imaginarium::MessageAdapter.send_to_channel(data)
      end
    end
  end
end
