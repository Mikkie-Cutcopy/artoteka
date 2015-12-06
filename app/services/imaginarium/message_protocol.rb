module Imaginarium::MessageProtocol
  module Statement
    class Base
      include Redis::Objects

      def id
        @auth_token ||= SecureRandom.hex
      end

      alias_method :auth_token, :id

      def initialize(object=nil)
        Redis::Objects.redis = MessageAdapter.redis_instance
        object.update_attribute(:auth_token, auth_token) if object.respond_to?(:auth_token)
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