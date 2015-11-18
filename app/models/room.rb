class Room < ActiveRecord::Base
  has_many  :gamers
  validates  :number, uniqueness: true

  def self.activate(owner, owner_email)
    @created_room = create(number: number_gen(/\d{5}/.gen), active: false)
    Gamer.create(name: owner, email: owner_email, owner: true, room: @created_room)
    @created_room
  rescue
    raise ArgumentError, 'something went wrong'
  end

  def owner
    players.where(owner: true).take
  end

  private

  def self.number_gen(n)
    (pluck(:number).include?(n) && n.to_s.length.eql?(5)) ? number_gen(n) : n
  end
end
