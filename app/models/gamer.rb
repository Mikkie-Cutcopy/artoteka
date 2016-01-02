class Gamer < ActiveRecord::Base
  belongs_to :room
  belongs_to :user

  validates :redis_token, presence: true
end