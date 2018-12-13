class CommentController < ApplicationController
  def create
    paramater = {micropost_id: params[:micropost_id], content: params[:content]}
    @comment = current_user.comments.build paramater
    @comment.save
    @json = {user: current_user.name ,content: params[:content]}

    respond_to do |format|
      format.json {
        render json: @json
      }
    end
  end

  def delete
  end
end
