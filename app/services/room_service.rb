module RoomService
  module_function

  DIGIT_COUNT = 7

  def activate_room(owner, owner_email)
    ActiveRecord::Base.transaction do
      user = User.find_or_create_by(name: owner, email: owner_email)
      room = Room.create(number: Imaginarium::MessageProtocol.generate_redis_token,  active: false)
      gamer = Gamer.create(user: user, room: room, owner: true)
      Imaginarium::RedisModel::Room.new.bind_to!(room) << gamer
      #Imaginarium::MessageAdapter.subscribe_to_channel(room.number.to_s)
      room
    end
  end

  def add_gamer(room_id, user_name, user_email)
    ActiveRecord::Base.transaction do
      user  = User.find_or_create_by(name: user_name, email: user_email)
      room  = Room.find(room_id)
      gamer = Gamer.find_or_create_by(user: user, room: room)
      #Imaginarium::MessageAdapter.subscribe_to_channel(room.number.to_s)
      gamer
    end
  end
end