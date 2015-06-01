require 'imaginarium_game'
require 'spec_helper'
require 'rails_helper'

RSpec.describe ImaginariumGame do

  before(:example) do

    @player1, @player2, @player3, @player4, @player5 = Array.new(5).each_with_index.map do |val, index|
      Player.create(name: "player#{index}", email: "player#{index}@mail.com")
    end

    @players = [@player1, @player2, @player3, @player4, @player5]

  end

  it 'start the game' do
    @match = ImaginariumGame::Match.start!(11111, @players)
    expect(@match.class).to eq(ImaginariumGame::Match)
  end

end