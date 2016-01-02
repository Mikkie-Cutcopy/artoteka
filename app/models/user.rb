class User < ActiveRecord::Base
  default_value_for :redis_token do
    Imaginarium::MessageProtocol.generate_redis_token
  end

  has_many :gamers
  has_many :rooms, through: :gamers

  validates :name, :email, presence: true
  validates :email, uniqueness: {message: "should be uniq in room"}
end