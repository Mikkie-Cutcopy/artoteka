require 'imaginarium_game'
require 'spec_helper'
require 'rails_helper'

RSpec.describe ImaginariumGame do

  before(:context) do
    @users = Array.new(5).each_with_index.map do |val, index|
      Player.create(name: "player#{index}", email: "player#{index}@mail.com")
    end
    @match = ImaginariumGame::Match.start!(11111, @users)
    @players = @match.players
  end

  it 'start the game' do
    expect(@match.class).to eq(ImaginariumGame::Match)
    expect(@match.listen_actions).to eq('hello')
  end

end