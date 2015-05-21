require 'rubygems'
require 'redis'
require 'json'


class MessageAdapter

  attr_writer :channel

  def self.start(socket)
    new(socket)
  end

  def initialize(socket)
    @socket = socket
    @redis = Redis.new(:timeout => 0)

    @redis.subscribe('rubyoddnrails') do |on|
      on.message do |channel, msg|
        #data = JSON.parse(msg)
        puts 'im in redis'
        @socket.send_data "##{channel} -  #{msg}"
      end
    end
  end

  def send_to_user(data)
    @socket.send_data(data)
  end

  def send_to_channel(data)
    @redis.publish 'rubyonrails', data.to_json
  end
end
