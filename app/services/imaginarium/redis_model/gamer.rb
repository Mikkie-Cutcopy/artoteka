module Imaginarium::RedisModel
  class Gamer < Base
    belongs :room
    value :name
  end
end
