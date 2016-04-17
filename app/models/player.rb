class Player < ActiveRecord::Base
  include RedisModelAccess
  self.table_name = :gamers

  belongs_to :room
  belongs_to :user

  after_create :bind_redis_object
  #validates :redis_token, presence: true
end