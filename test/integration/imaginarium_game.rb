Rspec.describe ImaginariumGame do

  before(:example) do
    @player1 = Player.create(name: "player1", email: "player1@mail.com")
    @player2 = Player.create(name: "player2", email: "player2@mail.com")
    @player3 = Player.create(name: "player3", email: "player3@mail.com")
    @player4 = Player.create(name: "player4", email: "player4@mail.com")
  end

  it 'start the game' do
    @match = ImaginariumGame::Match.start!(11111, @players)
  end

end