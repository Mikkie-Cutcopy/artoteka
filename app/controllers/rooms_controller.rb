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
        @room = Room.registration(owner_params)
        append_cookies(cookie_attributes)
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

  def owner_params
    params.require(:owner).permit(:name, :email)
  end

  def cookie_attributes
    {imaginarium_owner_name: params[:owner][:name],
     imaginarium_owner_email: params[:owner][:email]}
  end

end
