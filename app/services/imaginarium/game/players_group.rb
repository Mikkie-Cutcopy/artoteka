module Imaginarium
  class PlayersGroup < Array

    def self.build(names)
      self.new(names.map{|n| Player.new(name: n)})
    end

    def initialize(players=nil)
      @group = players
    end

    def <<(player)
      @group << player
    end

    def [](n)
      @group[n]
    end

    def key_player
      @group.first
    end

    def next_key_player!
      @group.rotate!
      key_player
    end
  end
end