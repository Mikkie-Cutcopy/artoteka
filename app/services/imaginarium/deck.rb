module Imaginarium
class Deck

  CARDS_COUNT = {4 => 96, 5 => 75, 6 => 72, 7 => 98}

  def self.create!(players_count)

    new(players_count)
  end



  def initialize(players_count)
    cards_count = CARDS_COUNT[players_count]
    full_deck = (1..98).to_a.shuffle
    @current_deck = cards_count.eql?(98) ? full_deck : full_deck[1..cards_count]

    @card = Chain::ChainObject.new(@current_deck.map{|number| Card.new(number, :fresh, nil, nil)})

  end

  def hand_out
    @match.players.each do |p|
      5.times do
        @card.current.tap do |card|
          card.status = :active
          card.owner  = p
          p.current_cards << card
        end
        @card.next!
      end
    end
  end

  def add_cards_to_players
    response = true
    @match.players.each do |p|
      if p.current_cards.count.eql?(4)
        if @card.next! == nil
          response = false
        else
          p.current_cards << @card.current
        end
      end
    end
    response
  end

  def to_a
    @cards
  end

end
end