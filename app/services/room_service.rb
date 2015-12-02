module RoomService
  module_function

  DIGIT_COUNT = 7

  def activate_room!(owner, owner_email)
    room = Room.create(number: generate_number, active: false)
    room.gamers.find_or_create_by(name: owner, email: owner_email, owner: true)
    MessageAdapter.subscribe_to_channel(room.number.to_s)
    room
  end

  def generate_number
    tmp = /\d{#{DIGIT_COUNT}}/.gen
    Room.pluck(:number).include?(tmp) ? generate_number : tmp
  end
end