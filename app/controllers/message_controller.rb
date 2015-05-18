require 'redis'
require 'json'
require 'message_adapter'


class MessageController < ApplicationController
  include Tubesock::Hijack

  def message
    hijack do |tubesock|

      tubesock.onopen do
        tubesock.send_data("hello from server")
        #@message_adapter = MessageAdapter.start(tubesock)
      end

      tubesock.onmessage do |data|
        #@message_adapter.send_to_channel(data)
        tubesock.send_data(data)
      end

    end
  end

end
