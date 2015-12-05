class SessionsController < ApplicationController

  def new
    @room_number = params[:room_number].to_i
    respond_to do |format|
      format.js   {render 'sessions/new'}
    end
  end

  def create
    @room = Room.find_by_number(params[:room_number])
    if @room
      RoomService.add_gamer(@room.id, params[:owner], params[:owner_email])
      respond_to do |format|
        format.js   {render 'rooms/show'}
      end
      Imaginarium::MessageAdapter.send_to_client(JSON.generate(authenticity_token: params[:authenticity_token]))
    else
      Imaginarium::MessageAdapter.send_to_client(JSON.generate(error: 'Resource not found', status: 404))
      render nothing: true
    end
  end

end
