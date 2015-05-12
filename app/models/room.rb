class Room < ActiveRecord::Base
  has_many :players

  def owner
    Player.find(owner_id)
  end
end
