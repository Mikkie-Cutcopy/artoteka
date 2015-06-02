require 'imaginarium_game'
require 'spec_helper'
require 'rails_helper'

RSpec.describe ImaginariumGame do

  before(:context) do
    @players_count = 5
    @users = Array.new(@players_count).each_with_index.map do |val, index|
      Player.create(name: "player#{index}", email: "player#{index}@mail.com")
    end
    @match = ImaginariumGame::Match.start!(11111, @users)
    @players = @match.players
  end

  it 'start settings' do
    expect(@match.class).to eq(ImaginariumGame::Match)
  end

  it 'initial listen actions' do
    expect(@match.listen_actions.values.count(:get_key_card)).to eq(1)
    expect(@match.listen_actions.values.count(nil)).to eq(@players_count - 1)
  end

  it 'get key card action' do
    expect(@match.key_player.listen_action).to eq(:get_key_card)

    @match.key_player.action :get_key_card, card_number: 17, phrase: 'Mysterious adventure'

    expect(@match.key_player.listen_action).to eq(nil)
    expect(@match.listen_actions.values.count(nil)).to eq(1)
    expect(@match.listen_actions.values.count(:get_card)).to eq(@players_count - 1)
  end

end