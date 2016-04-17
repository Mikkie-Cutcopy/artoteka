module Imaginarium::Model
  class Room < Imaginarium::RedisModel::Base
    has :gamers
    has :model
    has :chat
    value :status
    value :room_number

    def bind_to!(object)
      self.room_number = object.number
      super
    end

  end
end
