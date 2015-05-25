class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def set_cookies(cookie_params)
    cookie_params.each do |cookey, cooval|
      cookies.signed.permanent[cookey] = cooval
    end
  end

end
