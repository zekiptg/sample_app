class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
    only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "notify.info.passreset"
      redirect_to root_path
    else
      flash.now[:danger] = t "notify.danger.passreset"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      emptyerror = t "notify.errors.passempty"
      @user.errors.add :password, emptyerror
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t "notify.success.passreset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return render "users/errorFind" unless @user
  end

  def valid_user
    return redirect_to root_path unless @user&.activated?
      &.authenticated?:reset, params[:id]
  end

  def expired_action
    flash[:danger] = t "notify.danger.expire"
    redirect_to new_password_reset_path
  end

  def check_expiration
    expired_action if @user.password_reset_expired?
  end
end
