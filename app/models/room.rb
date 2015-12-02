class Room < ActiveRecord::Base
  has_many  :gamers
  validates  :number, uniqueness: true

  def owner
    players.where(owner: true).first
  end

end
