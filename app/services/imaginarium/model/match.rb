module Imaginarium::Model
  class Match < Imaginarium::RedisModel::Base
    belongs :room
    value :status
  end
end
