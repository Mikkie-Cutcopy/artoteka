class MessageController < ApplicationController
  include Tubesock::Hijack

  def message
    hijack do |tubesock|
      tubesock.onopen do
        tubesock.send_data "Hello, friend"
      end

      tubesock.onmessage do |data|
        tubesock.send_data "You said: #{data}"
      end
    end
  end

end
