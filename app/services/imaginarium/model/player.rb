module Imaginarium::Model
  class Player < Imaginarium::RedisModel::Base
    belongs :room
    value :name
  end
end
