class Room < ActiveRecord::Base
  default_value_for :redis_token do
    Imaginarium::MessageProtocol.generate_redis_token
  end
  has_many  :gamers
  has_many  :users, through: :gamers
  validates  :number, uniqueness: true

  def owner
    players.where(owner: true).first
  end

end
