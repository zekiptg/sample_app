class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :create
  before_action :destroy_valid, only: :destroy
  before_action :follow_valid, only: :show

  def create
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def show
    if @following == "true"
      @title = t "keywords.home.following"
      @users = @user.following.paginate page: params[:page],
        per_page: Settings.paginate.perpage
    else
      @title = t "keywords.home.followers"
      @users = @user.followers.paginate page: params[:page],
        per_page: Settings.paginate.perpage
    end
    render :show_follow
  end

  private

  def load_user
    @user = User.find_by params[:followed_id]
    return render "users/errorFind" unless @user
  end

  def destroy_valid
    @user = Relationship.find_by(params[:id]).followed
    return render "users/errorFind" unless @user
  end

  def follow_valid
    @user = User.find_by params[:id]
    @following = params[:following]
    return render "users/errorFind" unless @user
  end
end
