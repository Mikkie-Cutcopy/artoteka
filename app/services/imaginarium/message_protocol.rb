module Imaginarium::MessageProtocol
  module Statement
    class Base
      include Redis::Objects

      def id
        @auth_token ||= SecureRandom.hex
      end

      alias_method :auth_token, :id

      def initialize
        #TODO replace with connection pool
        Redis::Objects.redis = Imaginarium::MessageAdapter.redis_instance
      end

      def bind_to!(object)
        if object.class.name == self.class.name.split('::').last && object.redis_token
          @auth_token = object.redis_token
        else
          #TODO something going wrong
        end
      end
    end
  end

  class Room < Statement::Base
    hash_key :gamers
    value :chat
    value :status
  end

  class Gamer < Statement::Base
    value :name
  end

  class Chat < Statement::Base
  end
end