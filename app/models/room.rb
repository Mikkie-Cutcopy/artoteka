class Room < ActiveRecord::Base
  has_many  :players
  validates  :number, uniqueness: true

  def self.activate(owner, owner_email)
    begin
      Player.create(name: owner, email: owner_email, owner: true, room: create(number: number_gen(/\d{4}/.gen), active: false) ).room
    rescue
      raise ArgumentError, 'something went wrong'
    end
  end

  def owner
    players.where(owner: true).first
  end

  private

  def self.number_gen(n)
    (pluck(:number).include?(n) && n.to_s.length.eql?(4)) ? number_gen(n) : n
  end
end
