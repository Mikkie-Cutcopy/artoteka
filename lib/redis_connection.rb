require 'rubygems'
require 'redis'
require 'json'


class RedisConnection

  def initialize(socket)
    @socket = socket
  end

  def send_message(data)
    @socket.send_data(data)
  end

  def self.redis_onopen(tubesock)
    $redis = Redis.new(:timeout => 0)

    $redis.subscribe('rubyonrails', 'ruby-lang') do |on|
      on.message do |channel, msg|
        data = JSON.parse("{msg:'hello_world!', b: '2'}")
        tubesock.send_data "##{channel} - [#{data['user']}]: #{data['msg']}"
      end
    end
  end
end