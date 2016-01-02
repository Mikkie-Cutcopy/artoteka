class RoomsController < ApplicationController
  protect_from_forgery except: :show

  def new
    respond_to do |format|
      format.js   {render 'rooms/new'}
    end
  end

  def create
    respond_to do |format|
      format.js   {
        @room = RoomService.activate_room(params[:owner], params[:owner_email])
        append_cookies(imaginarium_name: params[:owner],
                       imaginarium_email: params[:owner_email]
        )
        @redis_token = @room.owner.redis_token
        render 'rooms/show'}
    end
  end

  def show
    @room = Room.find_by_number(params[:number].to_i)
    respond_to do |format|
      format.js   {render 'rooms/show'}
      format.html {render 'rooms/show'}
    end
  end

  private

  def room_params
    params.require(:room).permit(:owner, :owner_email, :number)
  end

end
