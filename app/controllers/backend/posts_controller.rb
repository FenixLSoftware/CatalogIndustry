class Backend::PostsController < Backend::AdminController

  before_action :set_post, only: [:like, :show, :edit, :update, :destroy, :remove_picture]


  def search
    index
    render 'index'
  end

  def destroy
    if @post.user == current_user || current_user.role_admin?
      @post.destroy
      gflash :success => t('m.deleted_new')
      redirect_to backend_posts_path, notice: 'Post deleted'
    else
      redirect_to backend_posts_path
    end

  end

  def remove_picture
    @post.remove_picture!
    @post.save
    redirect_to edit_backend_post_path(@post)
  end

  def index

    if current_user.role_admin?

      @post_all = Post.all

    else

      @post_all = Post.where(user: current_user).order(created_at: :desc)
      # @catalogs_published = Catalog.where(user: current_user).where(published: true).order(created_at: :desc)
      # @catalogs_not_published = Catalog.where(user: current_user).where(published: false).order(created_at: :desc)

    end

    @title = "Todas las notas de prensa"

    @all = true
    @active = [true, false]
    if params['active']=='1'
        @post_all = @post_all.where(published: true)
         @all = false
         @active = true

         @title = "Notas de prensa activas"
    end

    if params['active']=='0'
      @post_all = @post_all.where(published: false)
       @all = false
       @active = false
       @title = "Notas de prensa inactivas"
    end

    if params['search'].present?
      search = params[:search]
      @post_all = Post.search search ,misspellings: {below: 2}, where: {published: @active, id: @post_all.map(&:id) }, page: params[:page], per_page: 20
    else
      search = '*'


      @post_all = Post.search search ,misspellings: {below: 2}, where: {published: @active, id: @post_all.map(&:id) }, order: { created_at: :desc}, page: params[:page], per_page: 20

    end

    @title = @title + ' conteniendo ' + params[:search].to_s
    # @catalogs_published = Catalog.where(published: true).order(created_at: :desc)
    # @catalogs_not_published = Catalog.where(published: false).order(created_at: :desc)
    respond_to do |format|
       format.html # index.html.erb
       format.js
    end

  end
    def set_post
      @post = Post.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.


  # GET /authors/new
  def new
    @post = Post.new
    @post.translations.build
    @title = "Nueva nota de prensa"
  end

  # GET /authors/1/edit
  def edit
    @title = "Editando: " + @post.title.to_s
  end


  def create
    @title = "Nueva nota de prensa"
    @post = Post.new(posts_params)

    @post.user = current_user

    if current_user.trust?
      @post.validated = true
    end

    respond_to do |format|
      if @post.save
        sleep(2)
        gflash :success => t('m.created_ok')
        format.html { redirect_to backend_posts_path }
        #format.json { render :show, status: :created, location: @catalog }
      else
        gflash :warning => t('m.review_info')
        format.html { render :new }
        #format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @title = "Editando: " + @post.title.to_s
    respond_to do |format|

      if @post.update_attributes(posts_params)

        if current_user.role_admin?
          unless @post.user.trust?
            if @post.validated?
              u = @post.user
              u.trust = true
              u.save
              #aqui mandar el mail de item validado

            end
          end
        end
        gflash :success => t('m.updated_new')
        format.html { redirect_to backend_posts_path}
        #format.json { render :show, status: :ok, location: @catalog }
      else
        format.html { render :edit }
        #format.json { render json: @catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def posts_params
      params.require(:post).permit(:validated, :picture, :published,
                                  translations_attributes: [:id,
                                                            :title,
                                                            :slug,
                                                            :locale,
                                                            :description],)
    end


end
