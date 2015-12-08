module Imaginarium::RedisModel
  class Game < Base
    belongs :room
    value :status
  end
end