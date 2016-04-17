require 'active_support/concern'

module RoomService
  extend ActiveSupport::Concern

  class_methods do

    def registration(owner_params)
      create!(room_attributes).tap do |r|
        r.users << User.find_or_create_by(owner_params)
        r.set_owner_player
      end
    end

    private

    def room_attributes
      {number: Connection::MessageProtocol.generate_redis_token, active: false}
    end

    def user_attributes(options)
      {name: options[:owner], email: options[:owner_email]}
    end

  end

  def set_owner_player
    return unless players.exists?
    players.order(:created_at).first.update_attributes(owner: true)
  end

  def add_player(options)
    players.create(options).tap do |player|
      redis_model << player
    end
  end

  def bind_to_redis_model!
    @redis_model ||= Imaginarium::RedisModel::Room.new.bind_to!(self)
  end

  def destroy_room
  end

  def remove_player(user_id)
  end
end