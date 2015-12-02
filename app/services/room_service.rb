module RoomService
  module_function

  DIGIT_COUNT = 7

  def activate_room!(owner, owner_email)
    room = Room.create(number: generate_number, active: false)
    user = User.find_or_create_by(name: owner, email: owner_email)
    room.gamers.find_or_create_by(
      user_id: user.id,
      owner: true
    )
    MessageAdapter.subscribe_to_channel(room.number.to_s)
    room
  end

  def add_gamer(room_id, user_name, user_email)
    room = Room.find(room_id)
    gamer = room.gamers.find_or_create_by(user_id: User.find_or_create_by(name: user_name, email: user_email).id)
    MessageAdapter.subscribe_to_channel(room.number.to_s)
    gamer
  end

  def generate_number
    tmp = /\d{#{DIGIT_COUNT}}/.gen
    Room.pluck(:number).include?(tmp) ? generate_number : tmp
  end
end