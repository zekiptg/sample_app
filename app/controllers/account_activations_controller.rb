class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "notify.success.activated"
      redirect_to user_path
    else
      flash[:danger] = t "notify.danger.invalidActive"
      redirect_to root_path
    end
  end
end
