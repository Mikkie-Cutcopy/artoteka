module ImaginariumGame
class Match

  attr_reader :players, :room, :current_iteration, :history

  @@active_rooms = []

  def self.start!(room, users, first=nil)
    self.new(room, users, first)
  end

  def initialize(room, users, first=nil)
    if (4..7).include?(users.try(:count)) && room.is_a?(Fixnum) && !(@@active_rooms.include?(room))
      @room = room; @history = []; @current_iteration = nil
      @players = users.each_with_index.map do |user, i|
        Player.new(user, self, i)
      end
      @first_key_player =  (first && first.is_a?(Fixnum) && @players[first]) ? first : (/\d{1}/.gen.to_i)
      @players_cycle = Chain::ChainObject.new(@players, cycle: :true, set_to: @first_key_player)

      @deck_of_cards = Deck.create!(@players.count, self)
      @deck_of_cards.hand_out
      manage_iteration
      @@active_rooms << @room
    else
      raise ArgumentError
    end
  end

  def manage_iteration
    run_iteration #FIXME
  end

  def end_iteration
    if @current_iteration && @current_iteration.status.eql?(:closed)

      @current_iteration.players_results.each do |player, result|
        player.score += result[:score]
      end
      @players.each do |p|
        p.current_cards = p.current_cards.select{|c| c.status == :active}
      end
      @history << @current_iteration
      @current_iteration = nil
      #FIXME out of @@active_rooms and clear memory
      manage_iteration
    end
  end

  def listen_actions
    response = {}
    @players.each do |p|
      response.merge!(p.name => p.listen_action)
    end
    response
  end

  def key_player(action=nil)
    case action
      when nil
        @players_cycle.current
      when :set_next
        @history.empty? ? @players_cycle.current : @players_cycle.next!
    end
  end

  def game_over
    self
  end

  private

  def run_iteration
    unless @current_iteration
      key_player :set_next
      if @deck_of_cards.add_cards_to_players
        @current_iteration = Iteration.new(self)
        @current_iteration.status = :open
      else
        game_over
      end
      #@@active_rooms << @room
    end
  end

end
end