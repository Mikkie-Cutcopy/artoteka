module Imaginarium::RedisModel
  class Room < Base
    has :gamers
    has :game
    has :chat
    value :status
  end
end
