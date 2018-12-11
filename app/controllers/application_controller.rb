class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  include SessionsHelper

  def hello
    render html: "hello, world!"
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    loginaction unless logged_in?
  end

  def loginaction
    store_location
    flash[:danger] = t "notify.danger.login"
    redirect_to login_path
  end
end
