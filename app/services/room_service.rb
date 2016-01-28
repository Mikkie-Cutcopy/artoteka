module RoomService
  module_function

  def activate_room(owner, owner_email)
    room_number = Room.generate_number
    ActiveRecord::Base.transaction do
      user = User.find_or_create_by(name: owner, email: owner_email)
      room = Room.create!(number: room_number,  active: false)
      gamer = user.gamers.create!(redis_token: user.redis_token, owner: true)
      room.gamers << gamer
      room.redis_object.set_gamers = [gamer.redis_object]
      room
    end
  end

  def add_gamer(room_id, user_name, user_email)
    ActiveRecord::Base.transaction do
      user  = User.find_or_create_by(name: user_name, email: user_email)
      room  = Room.find(room_id)
      gamer = user.gamers.find_or_create_by(redis_token: user.redis_token)
      room.gamers << gamer
      room.redis_object.set_gamers = [gamer.redis_object]
      #redis_room.action!(:refresh)
      gamer
    end
  end
end