require 'redis'
require 'json'

class MessageController < ApplicationController
  include Tubesock::Hijack

  def message
    hijack do |tubesock|

      tubesock.onopen do

        $redis = Redis.new(:timeout => 0)

        $redis.subscribe('rubyonrails', 'ruby-lang') do |on|
          on.message do |channel, msg|
            data = JSON.parse(msg)
             tubesock.send_data "##{channel} - [#{data['user']}]: #{data['msg']}"
          end
        end
        #tubesock.send_data "Hello, friend"
      end

      tubesock.onmessage do |data|
        $redis.publish 'rubyonrails', data.to_json
        tubesock.send_data "You said: #{data}"
      end

    end
  end

end
