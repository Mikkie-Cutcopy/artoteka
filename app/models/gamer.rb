class Gamer < ActiveRecord::Base
  include RedisModelAccess

  belongs_to :room
  belongs_to :user

  after_create :bind_redis_object
  validates :redis_token, presence: true
end