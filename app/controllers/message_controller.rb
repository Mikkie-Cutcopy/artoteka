require 'redis'
require 'json'
require 'message_adapter'


class MessageController < ApplicationController
  include Tubesock::Hijack

  def message
    hijack do |tubesock|
      #on connect with server
      tubesock.onopen do
        MessageAdapter.start(tubesock)
      end

      #on message by user
      tubesock.onmessage do |data|
        MessageAdapter.send_to_channel(data)
      end
    end
  end
end
