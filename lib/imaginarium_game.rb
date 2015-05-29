module ImaginariumGame

  class Player

    COLORS = [:black, :white, :green, :blue, :red, :pink, :orange]
    STATUSES = [:getting_card, :waiting, :getting_number]

    attr_reader :owner, :status, :color

    def initialize(user, i, current_iteration)
      @owner, @color, @current_iteration = user, COLORS[i], current_iteration
    end

    def get_card(phrase, number)

    end

    def get_number(number)

    end

  end

  class Match


    def self.start!(room, users)
      self.new(room, users)

    end

    def initialize(room, users)
      @room = room
      @current_iteration = GameIteration.new
      @players = users.each_with_index.map do |user, i|
        Player.new(user, i, @current_iteration)
      end
    end

    def update_player_statuses

    end

  end

  class GameIteration

  end

  class Queue

    def initialize(players)
      @uc = users_count
    end

    def current_map

    end

  end

end


