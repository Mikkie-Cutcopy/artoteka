class Room < ActiveRecord::Base
  include RedisModelAccess
  include RoomService
  include UniqNumbers

  default_value_for :redis_token do
    Connection::MessageProtocol.generate_redis_token
  end
  has_many  :players
  has_many  :users, through: :players
  validates  :number, uniqueness: true

  after_create :bind_redis_object

  def owner
    players.where(owner: true).first
  end

end
