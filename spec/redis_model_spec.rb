require 'spec_helper'
require 'rails_helper'

RSpec.describe Imaginarium::RedisModel do
  describe 'relation methods' do
    let (:room) {Imaginarium::RedisModel::Room.new}
    let (:gamer) {Imaginarium::RedisModel::Gamer.new}
    let (:gamer2) {Imaginarium::RedisModel::Gamer.new}
    let (:game) {Imaginarium::RedisModel::Game.new}

    it "check without values" do
      expect(room.get_gamers).to eq([])
      expect(gamer.get_room).to eq(nil)
    end

    it "check 'has :model' with values" do
      room.set_gamers = [gamer]
      expect(room.get_gamers.first.id).to eq(gamer.id)
      expect(gamer.get_room.id).to eq(room.id)
    end

    it "check 'belongs :model' with values" do
      gamer.set_room = room
      expect(room.get_gamers.first.id).to eq(gamer.id)
      expect(gamer.get_room.id).to eq(room.id)
    end

    it "add values to scope" do
      room.set_gamers = [gamer]
      room.set_gamers = [gamer]
      expect(room.get_gamers.count).to eq(1)
      room.set_gamers = [gamer2]
      expect(room.get_gamers.count).to eq(2)
    end

    it "detach values for 'belongs :model'" do
      room.set_gamers = [gamer, gamer2]
      expect(room.get_gamers.count).to eq(2)
      expect(gamer2.get_room.id).to eq(room.id)

      gamer2.detach_room
      expect(room.get_gamers.count).to eq(1)
      expect(gamer2.get_room).to eq(nil)
      expect(room.get_gamers.first.id).to eq(gamer.id)
    end

    it "detach values for 'has :models'" do
      room.set_gamers = [gamer, gamer2]
      expect(room.get_gamers.count).to eq(2)
      expect(gamer2.get_room.id).to eq(room.id)

      room.detach_gamers = [gamer2]
      expect(room.get_gamers.count).to eq(1)
      expect(gamer2.get_room).to eq(nil)
      expect(room.get_gamers.first.id).to eq(gamer.id)
    end

    it "detach values for 'has :model'" do
      room.set_game = game
      expect(room.get_game.id).to eq(game.id)
      expect(game.get_room.id).to eq(room.id)

      room.detach_game
      expect(room.get_game).to eq(nil)
      expect(game.get_room).to eq(nil)
    end
  end
end