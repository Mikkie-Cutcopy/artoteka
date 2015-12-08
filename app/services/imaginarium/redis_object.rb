module Imaginarium::RedisObject
  class Base
    include Redis::Objects

    def id
      @auth_token ||= Imaginarium::MessageProtocol.generate_redis_token
    end

    alias_method :auth_token, :id

    def initialize(attr={})
      #TODO replace with connection pool
      @auth_token = attr[:token] if attr[:token]
      Redis::Objects.redis = Imaginarium::MessageAdapter.redis_instance
    end

    def bind_to!(object)
      if object.class.name == self.class.name.demodulize && object.redis_token
        @auth_token = object.redis_token
        self
      else
        #TODO something went wrong
      end
    end

    #if you have 'list :gamers' you may add Gamer < ActiveRecord object, but it must have redis_token
    def <<(object)
      if object.redis_token
        method = object.class.name.downcase.pluralize.to_sym
        unless send(method).values.include?(object.redis_token)
          send(method) << object.redis_token
        end
      end
    end

    def self.redis_find(token)
      new(token: token)
    end

    def self.has(redis_model)
      if singularity?(redis_model.to_s)
        belongs redis_model
      else
        list redis_model
        define_method("set_#{redis_model.to_s}=") do |redis_objects|
          redis_objects.each do |redis_object|
            #if redis_model == redis_object.class.name.demodulize.downcase.to_sym
            send(redis_model.to_s) << redis_object.auth_token
          end
        end
        define_method("get_#{redis_model.to_s}") do
          send(redis_model).values.map do |auth_token|
            ("Imaginarium::RedisObject::" + redis_model.to_s.classify)
            .constantize.redis_find(auth_token)
          end
        end
      end
    end

    def self.belongs(redis_model)
      value redis_model
      define_method("set_#{redis_model.to_s}=") do |redis_object|
        if redis_model == redis_object.class.name.demodulize.downcase.to_sym
          send("#{redis_model.to_s}=", redis_object.auth_token)
        end
      end
      define_method("get_#{redis_model.to_s}") do
        ("Imaginarium::RedisObject::" + redis_model.to_s.classify)
        .constantize.redis_find(send(redis_model).value)
      end
    end

    def self.singularity?(str)
      str.pluralize != str && str.singularize == str
    end
  end

  class Room < Base
    has :gamers
    has :game
    has :chat
    value :status
  end

  class Gamer < Base
    belongs :room
    value :name
  end

  class Game < Base
    belongs :room
    value :status
  end

  class Chat < Base
  end
end