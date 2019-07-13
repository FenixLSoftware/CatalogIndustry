class Backend::FavoritesController < Backend::AdminController

  before_action :set_catalog, only: [:like, :show, :edit, :update, :destroy]




  def search

    index(params['search'])
    #render 'index'
  end

  def index(search = '')
    
    if params['search'].present?
      search = params['search']
    else
      search = '*'
      unless ['catalogs','products','posts','companies'].include? params[:kind]
        redirect_to root_path
        return
      end
    end
    
    if params['kind'] == 'catalogs'
      
      @favorite_items = current_user.likees(Catalog)
      @items_all = Catalog.search search ,misspellings: {below: 2}, where: {published: true, validated: true, id: @favorite_items.map(&:id) }, page: params[:page], per_page: 20
      #@items_all = Catalog.visible.where(id: @favorite_items.map(&:id)).order(created_at: :desc)
    end

    if params['kind'] == 'products'
      @favorite_items = current_user.likees(Product)
      @items_all = Product.search search ,misspellings: {below: 2}, where: {published: true, validated: true, id: @favorite_items.map(&:id) }, page: params[:page], per_page: 20
      #@items_all = Product.visible.where(id: @favorite_items.map(&:id)).order(created_at: :desc)

    end

    if params['kind'] == 'posts'
      @favorite_items = current_user.likees(Post)
      @items_all = Post.search search ,misspellings: {below: 2}, where: {published: true, validated: true, id: @favorite_items.map(&:id) }, page: params[:page], per_page: 20
      #@items_all = Post.visible.where(id: @favorite_items.map(&:id)).order(created_at: :desc)
    end
    if params['kind'] == 'companies'
      @favorite_items = current_user.likees(User)
      
      @items_all = User.search search ,misspellings: {below: 2}, where: { validated: true, id: @favorite_items.map(&:id) }, page: params[:page], per_page: 20      
      #@items_all = User.role_company.where(id: @favorite_items.map(&:id)).order(created_at: :desc)
    end

    

    # @catalogs_published = Catalog.where(published: true).order(created_at: :desc)
    # @catalogs_not_published = Catalog.where(published: false).order(created_at: :desc)
    respond_to do |format|
       format.html # index.html.erb
       format.js
    end

  end


  # GET /authors/new
  def new
    @catalog = Catalog.new
    @catalog.translations.build
    @title = "Nuevo catálogo"
  end

  # GET /authors/1/edit
  def edit
    @title = "Editando: " + @catalog.name.to_s
  end


  def create
    @title = "Nuevo catálogo"
    @catalog = Catalog.new(catalog_params)
    @catalog.user = current_user
    @catalog.categories << Category.where(id: params[:categories])

    respond_to do |format|
      if @catalog.save
        format.html { redirect_to backend_catalogs_path, notice: 'Creado correctamente' }
        #format.json { render :show, status: :created, location: @catalog }
      else
        format.html { render :new }
        #format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @title = "Editando: " + @catalog.name.to_s
    respond_to do |format|
      @catalog.categories = []
      @catalog.categories << Category.where(id: params[:categories])
      if @catalog.update_attributes(catalog_params)
        format.html { redirect_to backend_catalogs_path, notice: t('successfully_updated_record') }
        #format.json { render :show, status: :ok, location: @catalog }
      else
        format.html { render :edit }
        #format.json { render json: @catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog
      @catalog = Catalog.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def catalog_params
      params.require(:catalog).permit(:published,
                                  translations_attributes: [:id,
                                                            :name,
                                                            :locale,
                                                            :description,
                                                            :keywords,
                                                            :description,
                                                            :pdf])
    end

end
