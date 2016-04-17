class SessionsController < ApplicationController
  layout 'rooms'

  def new
    @room_number = params[:room_number].to_i
    respond_to do |format|
      format.js   {render 'sessions/new'}
    end
  end

  def create
    @room = Room.find_by_number(params[:room_number])
    if @room
      gamer = @room.add_player(owner: params[:owner], owner_email: params[:owner_email])
      @redis_token = gamer.redis_token
      respond_to do |format|
        format.js   {render 'rooms/show'}
      end
      redis = Imaginarium::MessageAdapter.redis_instance
      redis.publish('broadcast', {redirect: "true",redirect_url: "/rooms/#{params[:room_number]}"}.to_json)
    else
      render nothing: true
    end
  end

end
