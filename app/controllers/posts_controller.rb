class PostsController < ApplicationController


  before_action :set_post, only: [:like, :show]


  def like
    if current_user.present?
      current_user.toggle_like!(@post)
      redirect_to post_path(@post), flash: {notice: current_user.likes?(@post) ? "La noticia es una de tus favoritas" : 'Ya no es un favorito' }

    else
      redirect_to root_path, notice: 'Debes logarte'
    end

  end


  def index

    @title = "Todas las noticias"
    if params[:sort]=='1'
      @posts = Post.includes(:translations).visible_front.order(title: :asc).paginate(:page => params[:page], :per_page => 15)
    else
      @posts = Post.includes(:translations).visible_front.order(created_at: :desc).paginate(:page => params[:page], :per_page => 15)
    end

  end


  def show
    impressionist(@post, @post.user.id.to_s, :unique => [:session_hash])
    #register_visit((current_user.present? ? current_user : nil), 'N', @post.id, @post.user.id)
    @title = @post.title

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.friendly.find(params[:id])
  end
end
