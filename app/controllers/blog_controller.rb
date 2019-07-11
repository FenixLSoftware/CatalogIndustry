class BlogController < ApplicationController

  def index
    @posts = Post.visible_front.where(user: User.role_admin).order(created_at: :desc).paginate(:page => params[:page], :per_page => 6)
  end

end
