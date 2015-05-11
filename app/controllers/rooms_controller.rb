class RoomsController < ApplicationController

  def create
    @room = Room.create(owner: params[:owner], owner_email: params[:owner_email])
    respond_to do |format|
      format.js   {}
      format.json {render :create}
    end

  end

  private
  # Using a private method to encapsulate the permissible parameters is
  # just a good pattern since you'll be able to reuse the same permit
  # list between create and update. Also, you can specialize this method
  # with per-user checking of permissible attributes.
  def room_params
    params.require(:room).permit(:owner, :owner_email)
  end

end
