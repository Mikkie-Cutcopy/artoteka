module ImaginariumGame

  class Player

    COLORS = [:black, :white, :green, :blue, :red, :pink, :orange]

    attr_reader :owner, :color
    attr_accessor :listen_action, :key_player, :score

    def initialize(user, current_match)
      @owner, @color, @current_match, @listen_action, @key_player, @score = user, nil, current_match, nil, false, 0

      #set_color

    end

    def action(action_name, hash_params = {})
       @current_match.current_iteration.action(self, action_name, hash_params) if @current_match.current_iteration
    end

    def name
      @owner.name
    end

    private

   # def set_color
   #   @@players_count ||= {}
   #   @@players_count[@current_match.room]
   # end
  end

  class Match

    attr_reader :players, :room, :current_iteration

    @@active_rooms = []

    def self.start!(room, users)
      self.new(room, users)
    end

    def initialize(room, users)
      if (4..7).include?(users.try(:count)) && room.is_a?(Fixnum) && !(@@active_rooms.include?(room))
        @room = room; @history = []; @current_iteration = nil
        @players = users.each_with_index.map do |user, i|
          Player.new(user, self)
        end

        @deck_of_cards = DeckOfCards.create!(@players.count)

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
      @players_cycle ||= @players.rotate!(/\d{1}/.gen.to_i)
      case action
      when nil
        @players_cycle.first
      when :set_next
        @players_cycle.rotate!.first
      end
    end

    private

    def run_iteration
      unless @current_iteration
        key_player :set_next
        @current_iteration = GameIteration.new(self)
        #@@active_rooms << @room
      end
    end

  end

  class GameIteration

    #include Aspectory::Hook

    attr_reader  :phrase, :players_choice, :players_results
    attr_accessor :status
    #after :action, :try_to_end_iteration

    def initialize(match)
      @current_match = match; @status = :active; @next_after = {:get_key_card => :get_card, :get_card => :get_number, :get_number => nil}; @phrase = nil
      @players_choice, @players_results = {}, {}
      @current_match.players.each do |p|
        @players_choice.merge!(p => {:get_key_card => nil, :get_card => nil, :get_number => nil})
        @players_results.merge!(p => {:guess_key_card => nil, :guess_own_card => nil, :score => nil})
      end
      @current_match.key_player.listen_action = :get_key_card
    end

    def action(player, action, hash_params)
      #:get_card != :get_number
      if action.eql?(player.listen_action) && player.listen_action.present?
         player.listen_action = nil
         @players_choice[player][action], @phrase = hash_params[:card_number], hash_params[:phrase]
         refresh_listen_actions(action)
         try_to_end_iteration
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
        scoring
        self.status = :closed
        @current_match.end_iteration
      end
    end

    def scoring
      card_choices = @players_choice.map{|p, c| c[:get_card]}
      @players_choice.each do |player, choice|
        player_result = @players_results[player]
        score = 0
        if choice[:get_key_card] # for key player
          all_guess = card_choices.compact.all?{|v| v.eql?(key_card)}
          nobody_guess = !(card_choices.compact.any?{|v| v.eql?(key_card)})
          guess_key_card_count = card_choices.count(choice[:get_key_card])

          if all_guess
            score -= 3
          elsif nobody_guess
            score -= 2
          else
            score += 3
            score += guess_key_card_count
          end

          player_result[:guess_own_card] = guess_key_card_count

        else # for other players
          # score for guess key card
          if choice[:get_card].eql?(key_card)
            (score += 3)
            player_result[:guess_key_card] = true
          end
          # add scores for guess own card
          guess_own_card_count = card_choices.count(choice[:get_card])
          score += guess_own_card_count;  player_result[:guess_own_card] = guess_own_card_count
        end
        player_result[:score] = score
      end
    end

    def key_card
      @players_choice[@current_match.key_player][:get_key_card]
    end

    def iteration_summary
      {:players_choise => @players_choice, :players_results => @players_results}
    end

  end

  class DeckOfCards

    CARDS_COUNT = {4 => 96, 5 => 75, 6 => 72, 7 => 98}

    def self.create!(players_count)
      new(players_count)
    end

    def initialize(players_count)

    end

  end

  class Card
    attr_reader :number, :file_path
    attr_accessor :status, :owner
  end

end


