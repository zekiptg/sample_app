class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user&.authenticate(params[:session][:password])
      authenticate_create @user
    else
      flash.now[:danger] = I18n.t "notify.danger.emailInvalid"
      render :new
    end
  end

  def authenticate_create user
    log_in user
    if params[:session][:remember_me] == Settings.session.params.rememberme
      remember(user)
    else
      forget(user)
    end
    redirect_to user
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
