module RoomService
  module_function

  DIGIT_COUNT = 7

  def activate_room(owner, owner_email)
    ActiveRecord::Base.transaction do
      user = User.find_or_create_by(name: owner, email: owner_email)
      room = Room.create(number: generate_number, redis_token: generate_redis_token, active: false)
      Gamer.find_or_create_by(user: user, room: room, redis_token: generate_redis_token, owner: true)
      Imaginarium::MessageProtocol::Statement::Room.new.bind_to!(room)
      Imaginarium::MessageAdapter.subscribe_to_channel(room.number.to_s)
      room
    end
  end

  def add_gamer(room_id, user_name, user_email)
    ActiveRecord::Base.transaction do
      room  = Room.find(room_id)
      user  = User.find_or_create_by(name: user_name, email: user_email)
      gamer = Gamer.find_or_create_by(user: user, room: room)
      Imaginarium::MessageAdapter.subscribe_to_channel(room.number.to_s)
      gamer
    end
  end

  def generate_number
    tmp = /\d{#{DIGIT_COUNT}}/.gen
    Room.pluck(:number).include?(tmp) ? generate_number : tmp
  end

  def generate_redis_token
    SecureRandom.hex
  end
end