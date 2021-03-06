class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale
  private

  def append_cookies(options)
    options.each{|key, val| cookies.signed.permanent[key] = val}
  end

  def set_locale
    I18n.locale = :ru
  end
end
