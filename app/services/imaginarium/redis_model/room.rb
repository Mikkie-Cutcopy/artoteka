module Imaginarium::RedisModel
  class Room < Base
    has :gamers
    has :game
    has :chat
    value :status
    value :room_number

    def bind_to!(object)
      self.room_number = object.number
      super
    end

  end
end
