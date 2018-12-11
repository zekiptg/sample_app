class StaticPagesController < ApplicationController
  before_action :init_micropost, only: :home

  def home; end

  def help; end

  def about; end

  def contact; end

  private
  def micropost_current_user
    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.paginate page: params[:page],
      per_page: Settings.paginate.homeMicropost
  end

  def init_micropost
    micropost_current_user if logged_in?
  end
end
