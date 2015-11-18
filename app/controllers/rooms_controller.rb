
class RoomsController < ApplicationController

  protect_from_forgery except: :show

  def new
    #@testclass = GetTestclass.generate.inspect
    respond_to do |format|
      format.js   {render 'rooms/new'}
    end
  end

  def create
    @room = Room.activate(params[:owner], params[:owner_email])
    MessageAdapter.subscribe_to_channel(@room.number.to_s)
    {imaginarium_name: params[:owner], imaginarium_email: params[:owner_email]}.each do |key, val|
      cookies.signed.permanent[key] = val
    end
    respond_to do |format|
      format.js   {render 'rooms/show'}
    end
  end

  def show
    @room = Room.find_by_number(params[:number].to_i)
    render 'rooms/show'
  end

  private
  
  def room_params
    params.require(:room).permit(:owner, :owner_email, :number)
  end

end
