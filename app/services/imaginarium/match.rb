module Imaginarium
class Match

  attr_reader :players_group, :token, :current_iteration, :history
  attr_writer :players_group, :deck_of_cards

  def self.create_with!(*names)
    self.new(names)
  end

  def initialize(names)
      players_group = PlayersGroup.build(names)
      deck = Deck.hand_out!(players_group.count)
      iteration_manager = IterationManager.start!
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