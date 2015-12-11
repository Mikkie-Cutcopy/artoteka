class Gamer < ActiveRecord::Base
  default_value_for :redis_token do
    Imaginarium::MessageProtocol.generate_redis_token
  end
  belongs_to :room
  belongs_to :user
end