class SessionsController < ApplicationController

  def new
    @room_number = params[:room_number].to_i
    respond_to do |format|
      format.js   {render 'sessions/new'}
    end
  end


  def create
    @room = Room.find_by_number(params[:room_number])
    respond_to do |format|
      format.js   {render 'rooms/show'}
    end
    MessageAdapter.send_to_client(JSON.generate(authenticity_token: params[:authenticity_token]))
  end

end
