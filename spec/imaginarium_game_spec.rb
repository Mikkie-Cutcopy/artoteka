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
    @player = @match.players
  end

  it 'start settings' do
    expect(@match.class).to eq(ImaginariumGame::Match)
  end

  it 'initial listen actions' do
    expect(@match.listen_actions.values.count(:get_key_card)).to eq(1)
    expect(@match.listen_actions.values.count(nil)).to eq(@players_count - 1)
  end

  it 'get wrong actions' do
    @players_count.times do |n|
      @player[n].action :get_card, card_number: (17 + n)
      expect(@match.current_iteration.players_choice[@player[n]][:get_card]).to eq(nil)
      @player[n].action :get_number, card_number: (17 + n)
      expect(@match.current_iteration.players_choice[@player[n]][:get_number]).to eq(nil)

      unless @player[n].eql?(@match.key_player)
        @player[n].action :get_key_card, card_number: 17, phrase: 'Mysterious adventure'
        expect(@match.current_iteration.players_choice[@player[n]][:get_key_card]).to eq(nil)
      end
    end
  end

  #@players_choice.merge!(p => {:get_key_card => nil, :get_card => nil, :get_number => nil})
  it 'get key card action' do
    expect(@match.key_player.listen_action).to eq(:get_key_card)

    @match.key_player.action :get_key_card, card_number: 17, phrase: 'Mysterious adventure'

    expect(@match.key_player.listen_action).to eq(nil)
    expect(@match.listen_actions.values.count(nil)).to eq(1)
    expect(@match.listen_actions.values.count(:get_card)).to eq(@players_count - 1)

    @players_count.times do |n|
      if @player[n].eql?(@match.key_player)
        expect(@match.current_iteration.players_choice[@player[n]][:get_key_card]).to eq(17)
      else
        expect(@match.current_iteration.players_choice[@player[n]][:get_key_card]).to eq(nil)
      end
      expect(@match.current_iteration.players_choice[@player[n]][:get_card]).to eq(nil)
      expect(@match.current_iteration.players_choice[@player[n]][:get_number]).to eq(nil)
    end

  end

  it 'get card actions' do
    @players_count.times do |n|
      @player[n].action :get_card, card_number: (17 + n)
    end

    expect(@match.key_player.listen_action).to eq(nil)
    expect(@match.listen_actions.values.count(nil)).to eq(1)
    expect(@match.listen_actions.values.count(:get_number)).to eq(@players_count - 1)

    @players_count.times do |n|
      if @player[n].eql?(@match.key_player)
        expect(@match.current_iteration.players_choice[@player[n]][:get_key_card]).to eq(17)
      else
        expect(@match.current_iteration.players_choice[@player[n]][:get_key_card]).to eq(nil)
        expect(@match.current_iteration.players_choice[@player[n]][:get_card]).not_to eq(nil)
      end
      expect(@match.current_iteration.players_choice[@player[n]][:get_number]).to eq(nil)
    end
    #puts @match.current_iteration.players_choice.values
  end

  it 'get number actions' do
    @players_count.times do |n|
      @player[n].action :get_number, card_number: (15 + n)
    end

    expect(@match.listen_actions.values.count(:get_key_card)).to eq(1)
    expect(@match.listen_actions.values.count(nil)).to eq(@players_count - 1)

    @players_count.times do |n|
      expect(@match.current_iteration.players_choice[@player[n]][:get_key_card]).to eq(nil)
      expect(@match.current_iteration.players_choice[@player[n]][:get_card]).to eq(nil)
      expect(@match.current_iteration.players_choice[@player[n]][:get_number]).to eq(nil)
    end

    @players_count.times do |n|
      puts "player#{n} got: " + @player[n].score.to_s
    end
  end



end