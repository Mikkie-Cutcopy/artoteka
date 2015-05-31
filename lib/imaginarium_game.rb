module ImaginariumGame

  class Player

    COLORS = [:black, :white, :green, :blue, :red, :pink, :orange]

    attr_reader :owner, :color, :current_iteration, :id
    attr_accessor :listen_action, :key_player, :points

    def initialize(user, i, current_iteration)
      @owner, @id, @color, @current_iteration, @listen_action, @key_player = user, i, COLORS[i], current_iteration, nil, false
    end

    def action(action_name, hash_params = {})
      @current_iteration.action(self, action_name, hash_params)
    end
  end

  class Match

    attr_reader :players, :room

    def self.start!(room, users)
      self.new(room, users)
    end

    def initialize(room, users)
      @room = room, @history = nil
      @players = users.each_with_index.map do |user, i|
        Player.new(user, i, @current_iteration)
      end
      run_iteration
    end

    def end_iteration
      if @current_iteration
        @history << @current_iteration
        @current_iteration = nil
      end
    end

    private

    def run_iteration
      unless @current_iteration
        key_player :set_next
        @current_iteration = GameIteration.new(self)
      end
    end

    def key_player(action)
      @players_cycle ||= @players.rotate!(/\d{1}/.gen)
      case action
        when nil
          @players_cycle.first
        when :set_next
          @players_cycle.rotate!.first
      end
    end

  end

  class GameIteration

    include Aspectory::Hook

    attr_reader :status, :phrase, :players_results

    after :action, :try_to_end_iteration

    def initialize(match)
      @current_match = match, @status = :active, @next_after = {:get_key_card => :get_card, :get_card => :get_number, :get_number => nil}, @phrase = nil
      @players_choice = {}
      @current_match.players.each do |p|
        @players_choice.merge!(p => {:get_key_card => nil, :get_card => nil, :get_number => nil})
        @players_results.merge!(p => {:guess_key_card => nil, :guess_own_card => nil, :score => nil})
      end
    end

    def action(player, action, hash_params)
      if action.eql?(player.listen_action) # nil case
         player.listen_action = nil
         @players_choice[player][action], @phrase = hash_params[:card_number], hash_params[:phrase]
         refresh_listen_actions(action)
      end
    end

    private

    def refresh_listen_actions(current_action)
      if @current_match.players.map(&:listen_action).all?{|a| a.eql?(nil)}
        @current_match.players.each do |player|
          player.listen_action = @next_after[current_action] unless player.eql?(@current_match.key_player)
        end
      end
    end

    def try_to_end_iteration
      if @players_choice.all?{|player, choice| choice[:get_key_card] || (choice[:get_card] && choice[:get_number])}
        @players_choice.each do |player, choice|
          player_result = @players_results[player]

          

        end
        self.status = :closed
      end
    end

    def key_card
      @players_choice[@current_match.key_player][:get_key_card]
    end

    def iteration_summary

    end

  end

end


