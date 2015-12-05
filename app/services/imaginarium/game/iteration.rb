module Imaginarium::Game

class Iteration

  #include Aspectory::Hook

  attr_reader  :phrase, :players_choice, :players_results
  attr_accessor :status
  #after :action, :try_to_end_iteration

  def initialize(match)
    @current_match = match; @status = :active; @action = Chain::ChainObject.new([:get_key_card, :get_card, :get_number, nil]); @phrase = nil
    @players_choice, @players_results = {}, {}
    @current_match.players.each do |p|
      @players_choice.merge!(p => {:get_key_card => nil, :get_card => nil, :get_number => nil})
      @players_results.merge!(p => {:guess_key_card => nil, :guess_own_card => nil, :score => nil})
    end
    @current_match.key_player.listen_action = :get_key_card
  end

  def action(player, action, hash_params)
    #:get_card != :get_number
    card_number = hash_params[:card_number]
    card_number_is_valid = if [:get_card, :get_key_card].include?(action)
                             player.current_cards.map(&:number).include?(card_number)
                           elsif [:get_number].include?(action)
                             cards = @players_choice.values.map do |p_choice|
                               p_choice[:get_card] || p_choice[:get_key_card]
                             end
                             cards.include?(card_number)
                           end
    require_is_valid = action.eql?(player.listen_action) && player.listen_action.present? && card_number_is_valid

    if require_is_valid
      player.listen_action = nil
      card = player.current_cards.select{|c| c.number == card_number}.first
      card.status = :used if [:get_card, :get_key_card].include?(action)
      @players_choice[player][action], @phrase = hash_params[:card_number], hash_params[:phrase]
      refresh_listen_actions(action)
      try_to_end_iteration
    end
  end

  def iteration_summary
    {:players_choice => @players_choice.values, :players_results => @players_results.values}
  end

  private

  def refresh_listen_actions(current_action)
    if @current_match.players.map(&:listen_action).all?{|a| a.eql?(nil)}
      @action.next!
      @current_match.players.each do |player|
        player.listen_action = @action.current unless player.eql?(@current_match.key_player)
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
    card_choices = @players_choice.map{|p, c| c[:get_number]}
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
        if choice[:get_number].eql?(key_card)
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

end
end