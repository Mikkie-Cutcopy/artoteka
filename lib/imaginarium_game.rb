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
      @room = room
      @players = users.each_with_index.map do |user, i|
        Player.new(user, i, @current_iteration)
      end

      @current_iteration = GameIteration.new(self)
    end

  end

  class GameIteration

    def initialize(match)
      @current_match = match
      @current_actions_cycle = [:get_key_card, :get_card, :get_number]
      #players[0].status = :getting_key_card
    end

    def action(player, action, hash_params)
      if action.eql?(player.listen_action) # nil case
         player.listen_action = nil
         next_step?(player, action)
      end
    end

    private

    def next_step?(player, action)
      if @current_match.players.map(&:listen_action).all?{|la| la.eql?(nil)}

      end
    end

  end

  class Queue

    def initialize(players)
      @uc = users_count
    end

    def current_map

    end

  end

end


