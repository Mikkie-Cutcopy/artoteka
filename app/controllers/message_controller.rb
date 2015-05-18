require 'redis'
require 'json'
require  'redis_connection'


class MessageController < ApplicationController
  include Tubesock::Hijack

  def message
    hijack do |tubesock|

      tubesock.onopen do
         RedisConnection.redis_onopen(tubesock)
        #tubesock.send_data "Hello, friend"
      end

      tubesock.onopen do
        tubesock.send_data "Hello, friend"
      end

      tubesock.onmessage do |data|
        $redis.publish 'rubyonrails', data.to_json
        tubesock.send_data "You said: #{data}"
      end

    end
  end

end
