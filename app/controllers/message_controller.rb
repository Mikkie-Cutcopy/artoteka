require 'redis'
require 'json'
require 'message_adapter'


class MessageController < ApplicationController
  include Tubesock::Hijack

  def message
    hijack do |tubesock|

      tubesock.onopen do
        tubesock.send_data('hello everybody')
        #@message_adapter = MessageAdapter.start(tubesock)
        @redis = Redis.new(url: ENV["REDIS_URL"], driver: :hiredis)

         Thread.new do
          @redis.subscribe('rubyoddnrails') do |on|
            on.message do |channel, msg|
              #data = JSON.parse(msg)
              puts 'im in redis'
              tubesock.send_data "##{channel} -  #{msg}"
            end
          end
         end
      end

      tubesock.onmessage do |data|
        @redis = Redis.new(url: ENV["REDIS_URL"], driver: :hiredis)
        @redis.publish('rubyoddnrails', data)
      end

    end

  end

end
