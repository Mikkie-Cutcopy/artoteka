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

    attr_reader :status

    def initialize(match)
      @current_match = match, @status = :active,  @next_after = {:get_key_card => :get_card, :get_card => :get_number, :get_number => nil}
      #players[0].status = :getting_key_card
    end

    def action(player, action, hash_params)
      if action.eql?(player.listen_action) # nil case
         player.listen_action = nil
         next_step?(action)
      end
    end

    private

    def next_step?(current_action)
      if @current_match.players.map(&:listen_action).all?{|a| a.eql?(nil)}
        @current_match.players.each do |player|
          player.listen_action = @next_after[current_action] unless player.eql?(@current_match.key_player)
        end
        @current_match.end_iteration if current_action.eql?(:get_number)
      end
    end

    def iteration_summary

    end

  end

end


