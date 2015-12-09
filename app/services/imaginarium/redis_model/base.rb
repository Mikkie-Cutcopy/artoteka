module Imaginarium::RedisModel
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
        method = object.class.name.underscore.pluralize.to_sym
        unless send(method).values.include?(object.redis_token)
          send(method) << object.redis_token
        end
      end
    end

    def self.redis_find(token, redis_model=nil)
      if redis_model
        (name.deconstantize + "::" + redis_model.to_s.classify)
            .constantize.new(token: token)
      else
        new(token: token)
      end
    end

    def self.has(redis_model)
      if singularity?(redis_model.to_s)
        belongs redis_model
      else
        list redis_model
        define_method("set_#{redis_model.to_s}=") do |redis_objects|
          dependent_method = self.class.name.demodulize.underscore
          redis_objects.each do |redis_object|
            return if send(redis_model).values.include?(redis_object.id)
            return unless redis_model.to_s.pluralize == redis_object.underscored_class_name.pluralize
            send(redis_model.to_s) << redis_object.auth_token
            redis_object.send(dependent_method + "=", @auth_token)
          end
        end
        define_method("get_#{redis_model.to_s}") do
          send(redis_model).values.map do |auth_token|
            return unless send(redis_model.to_s).exists?
            (self.class.name.deconstantize + "::" + redis_model.to_s.classify)
                .constantize.redis_find(auth_token)
          end
        end
        define_method("detach_#{redis_model.to_s}=") do |redis_objects|
          dependent_method = self.class.name.demodulize.underscore
          redis_objects.each do |redis_object|
            return unless send(redis_model).values.include?(redis_object.id)
            return unless redis_model.to_s.pluralize == redis_object.underscored_class_name.pluralize
            send(redis_model.to_s).delete(redis_object.id)
            redis_object.send(dependent_method + "=", nil)
          end
        end
      end
    end

    def self.belongs(redis_model)
      value redis_model
      # Gamer.new.set_room= redis_object
      define_method("set_#{redis_model.to_s}=") do |redis_object|
        dependent_method = self.class.name.demodulize.underscore
        return unless redis_model.to_s.pluralize == redis_object.underscored_class_name.pluralize
        send("#{redis_model.to_s}=", redis_object.auth_token)

        if redis_object.respond_to?(dependent_method.to_sym)
          redis_object.send(dependent_method + "=", @auth_token)
        elsif redis_object.respond_to?(dependent_method.pluralize.to_sym)
          return if redis_object.send(dependent_method.pluralize).values.include?(@auth_token)
          redis_object.send(dependent_method.pluralize) << @auth_token
        end
      end
      # Gamer.new.get_room
      define_method("get_#{redis_model.to_s}") do
        return unless send(redis_model.to_s).exists?
        (self.class.name.deconstantize + "::" + redis_model.to_s.classify)
            .constantize.redis_find(send(redis_model).value)
      end

      define_method("detach_#{redis_model.to_s}") do
        redis_object = self.class.redis_find(send(redis_model).value, redis_model)
        return unless redis_object
        send("#{redis_model.to_s}=", nil)

        dependent_method = self.class.name.demodulize.underscore
        if redis_object.respond_to?(dependent_method.to_sym)
          redis_object.send(dependent_method + "=", nil)
        elsif redis_object.respond_to?(dependent_method.pluralize.to_sym)
          return unless redis_object.send(dependent_method.pluralize).values.include?(@auth_token)
          redis_object.send(dependent_method.pluralize).delete(@auth_token)
        end
      end
    end

    def underscored_class_name
      self.class.name.demodulize.underscore
    end

    def self.singularity?(str)
      str.pluralize != str && str.singularize == str
    end
  end
end