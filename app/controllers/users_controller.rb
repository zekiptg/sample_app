class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :load_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.activated.paginate page: params[:page],
      per_page: Settings.paginate.perpage
  end

  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts.paginate page: params[:page],
     per_page: Settings.paginate.perpage
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = t "notify.info.activemail"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "notify.success.update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "notify.success.delete"
    else
      flash[:danger] = t "notify.danger.delete"
    end
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit :name,
      :email, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return render "errorFind" unless @user
  end

  def logged_in_user
    loginaction unless logged_in?
  end

  def loginaction
    store_location
    flash[:danger] = t "notify.danger.login"
    redirect_to login_path
  end

  def correct_user
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def success_destroy user
    user.destroy
    flash[:success] = t "notify.success.delete"
    redirect_to users_path
  end
end
