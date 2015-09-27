module Imaginarium
  class Player

    COLORS = [:black, :white, :green, :blue, :red, :pink, :orange]

    attr_accessor  :score, :current_cards
    attr_reader :token

    state_machine :state, initial: :waiting do

      event :get_card do
        transition :waiting => :committed
      end

      event :call_number do
        transition :committed => :called
      end

      event :reset do
        transition :called => :waiting
      end
    end

    def initialize(name)
      @name = name
      @current_cards = nil
    end

    def name
      @owner.name
    end

    def token

    end

  end
end