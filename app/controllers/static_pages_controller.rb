class StaticPagesController < ApplicationController
  def init_micropost
    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.paginate page: params[:page],
      per_page: Settings.paginate.homeMicropost
  end

  def home
    init_micropost if logged_in?
  end

  def help; end

  def about; end

  def contact; end
end
