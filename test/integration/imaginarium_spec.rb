require 'spec_helper'
require 'rails_helper'

RSpec.describe Imaginarium do

  describe 'single iteration' do

    before(:context) do
      @players_count = 5
      @users = Array.new(@players_count).each_with_index.map do |val, index|
        Gamer.create(name: "player#{index}", email: "player#{index}@mail.com")
      end
      @match = Imaginarium::Match.start!(11111, @users, first: 0)
      @player = @match.players
      @key_player_card_num = @match.key_player.current_cards.first.number
    end

    it 'start settings' do
      expect(@match.class).to eq(Imaginarium::Match)
    end

    it 'initial listen actions' do
      expect(@match.listen_actions.values.count(:get_key_card)).to eq(1)
      expect(@match.listen_actions.values.count(nil)).to eq(@players_count - 1)
    end

    it 'get wrong actions' do

      @players_count.times do |n|
        @player[n].action :get_card, card_number: (@key_player_card_num + n)
        expect(@match.current_iteration.players_choice[@player[n]][:get_card]).to eq(nil)
        @player[n].action :get_number, card_number: (@key_player_card_num + n)
        expect(@match.current_iteration.players_choice[@player[n]][:get_number]).to eq(nil)

        unless @player[n].eql?(@match.key_player)
          @player[n].action :get_key_card, card_number: @key_player_card_num, phrase: 'Mysterious adventure'
          expect(@match.current_iteration.players_choice[@player[n]][:get_key_card]).to eq(nil)
        end
      end
    end

    #@players_choice.merge!(p => {:get_key_card => nil, :get_card => nil, :get_number => nil})
    it 'get key card action' do
      expect(@match.key_player.listen_action).to eq(:get_key_card)

      @match.key_player.action :get_key_card, card_number: @key_player_card_num, phrase: 'Mysterious adventure'

      expect(@match.key_player.listen_action).to eq(nil)
      expect(@match.listen_actions.values.count(nil)).to eq(1)
      expect(@match.listen_actions.values.count(:get_card)).to eq(@players_count - 1)

      @players_count.times do |n|
        if @player[n].eql?(@match.key_player)
          expect(@match.current_iteration.players_choice[@player[n]][:get_key_card]).to eq(@key_player_card_num)
        else
          expect(@match.current_iteration.players_choice[@player[n]][:get_key_card]).to eq(nil)
        end
        expect(@match.current_iteration.players_choice[@player[n]][:get_card]).to eq(nil)
        expect(@match.current_iteration.players_choice[@player[n]][:get_number]).to eq(nil)
      end

    end

    it 'get card actions' do

      @players_count.times do |n|
        @player[n].action :get_card, card_number: (@player[n].current_cards.first.number)
      end

      expect(@match.key_player.listen_action).to eq(nil)
      expect(@match.listen_actions.values.count(nil)).to eq(1)
      expect(@match.listen_actions.values.count(:get_number)).to eq(@players_count - 1)

      @players_count.times do |n|
        if @player[n].eql?(@match.key_player)
          expect(@match.current_iteration.players_choice[@player[n]][:get_key_card]).to eq(@key_player_card_num)
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
        @player[n].action :get_number, card_number: (@key_player_card_num)
      end

      expect(@match.listen_actions.values.count(:get_key_card)).to eq(1)
      expect(@match.listen_actions.values.count(nil)).to eq(@players_count - 1)

      @players_count.times do |n|
        expect(@match.current_iteration.players_choice[@player[n]][:get_key_card]).to eq(nil)
        expect(@match.current_iteration.players_choice[@player[n]][:get_card]).to eq(nil)
        expect(@match.current_iteration.players_choice[@player[n]][:get_number]).to eq(nil)
      end

    end

  end

  describe 'scoring' do

    before(:context) do
      @players_count = 5
      @users = Array.new(@players_count).each_with_index.map do |val, index|
        Gamer.create(name: "player#{index}", email: "player#{index}@mail.com")
      end
      @first_id = 0
      @match = ImaginariumGame::Match.start!(22222, @users, @first_id)
      @player = @match.players
    end

    it 'case 1' do
      expect(@match.listen_actions.values.count(:get_key_card)).to eq(1)
      expect(@match.listen_actions.values.count(nil)).to eq(@players_count - 1)
      expect(@match.key_player.id).to eq(@first_id)
      expect(@match.current_iteration.status).to eq(:open)

      @match.players.each do |p|
        expect(p.current_cards.count).to eq(5)
        expect(p.current_cards.map(&:status).count(:active)).to eq(5)
      end
      p @match.players.map(&:current_cards).flatten.map(&:number)

      key_player_card_num = @match.key_player.current_cards.first.number

    @match.key_player.action :get_key_card, card_number: key_player_card_num, phrase: 'Mysterious adventure'

    @player[1].action :get_card, card_number:   @player[1].current_cards.first.number #11
    @player[2].action :get_card, card_number:   @player[2].current_cards.first.number #12
    @player[3].action :get_card, card_number:   @player[3].current_cards.first.number #13
    @player[4].action :get_card, card_number:   @player[4].current_cards.first.number #14

    @player[1].action :get_number, card_number: key_player_card_num
    @player[2].action :get_number, card_number: key_player_card_num
    @player[3].action :get_number, card_number: @player[2].current_cards.first.number #12
      puts "summary: #{@match.current_iteration.iteration_summary}"
    expect(@match.history.count).to eq(0)
    @player[4].action :get_number, card_number: @player[2].current_cards.first.number  #12
      puts " "
      (0..4).each do |n|
        puts "#{@player[n].id} player#{n} got: " + @player[n].score.to_s
        puts "#{@player[n].id} key_player #{n}!" if @player[n] == @match.key_player
      end

    expect(@match.current_iteration.status).to eq(:open)
    expect(@match.history.count).to eq(1)
    expect(@match.key_player.id).to eq(@first_id + 1)
    end
  end

end