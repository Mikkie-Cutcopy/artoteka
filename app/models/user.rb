class User < ActiveRecord::Base
  has_many :gamers
  has_many :rooms, through: :gamers

  validates :name, :email, presence: true
  validates :email, uniqueness: {message: "should be uniq in room"}
end