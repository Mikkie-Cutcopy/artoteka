class StartController < ApplicationController

  def start

  end

  def new_room
    respond_to do |format|
      format.html {render 'start/show_new_room'}
      format.js   {render 'start/show_new_room'}
    end
  end

end
