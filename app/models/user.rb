class User < ActiveRecord::Base
  default_value_for :redis_token do
    Connection::MessageProtocol.generate_redis_token
  end

  has_many :players
  has_many :rooms, through: :players

  validates :name, :email, presence: true
  validates :email, uniqueness: {message: "should be uniq in room"}
end