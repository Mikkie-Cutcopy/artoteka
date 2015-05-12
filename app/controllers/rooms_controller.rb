class RoomsController < ApplicationController

  def new
    respond_to do |format|
      format.js   {render 'rooms/new'}
    end
  end

  def create
    @player = Player.create(name: params[:owner], email: params[:owner_email])
    Room.create(owner_id: @player.id)
    respond_to do |format|
      format.js   {render 'rooms/show'}
    end
  end

  private

  def room_params
    params.require(:room).permit(:owner, :owner_email)
  end

  def player_params
    params.require(:player).permit(:name, :email)
  end

end
