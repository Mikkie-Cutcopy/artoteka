class Player < ActiveRecord::Base
  belongs_to :room

  validates :name, :email, presence: true
  validates :email, uniqueness: {scope: :room_id, message: "should be uniq in room"}

end