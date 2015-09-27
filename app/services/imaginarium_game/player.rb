module ImaginariumGame
  class Player

    COLORS = [:black, :white, :green, :blue, :red, :pink, :orange]

    attr_reader :owner, :color, :id
    attr_accessor :listen_action, :key_player, :score, :current_cards

    def initialize(user, current_match, id)
      @owner, @color, @current_match, @listen_action, @key_player, @score, @id, @current_cards = user, nil, current_match, nil, false, 0, id, []
    end

    def action(action_name, hash_params = {})
      @current_match.current_iteration.action(self, action_name, hash_params) if @current_match.current_iteration
    end

    def name
      @owner.name
    end

  end
end