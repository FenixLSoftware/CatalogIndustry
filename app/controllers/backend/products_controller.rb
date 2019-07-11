class Backend::ProductsController < Backend::AdminController

  before_action :set_product, only: [:like, :show, :edit, :update, :destroy]




  def search
    index
    render 'index'
  end

  def destroy
    if @product.user == current_user || current_user.role_admin?
      @product.destroy
      gflash :success => t('m.deleted_product')
      redirect_to backend_products_path#, notice: 'Product deleted'
    else
      redirect_to backend_products_path
    end

  end

  def index

    if current_user.role_admin?

      @products_all = Product.all

    else

      @products_all = Product.where(user: current_user).order(created_at: :desc)
      # @catalogs_published = Catalog.where(user: current_user).where(published: true).order(created_at: :desc)
      # @catalogs_not_published = Catalog.where(user: current_user).where(published: false).order(created_at: :desc)

    end

    @title = "Todos los productos"

    @all = true
    @active = [true, false]
    if params['active']=='1'
        @products_all = @products_all.where(published: true)
         @all = false
         @active = true

         @title = "Productos activos"
    end

    if params['active']=='0'
      @products_all = @products_all.where(published: false)
       @all = false
       @active = false
       @title = "Productos inactivos"
    end

    if params['search'].present?
      search = params[:search]
      @products_all = Product.search search ,misspellings: {below: 2}, where: {published: @active, id: @products_all.map(&:id) }, page: params[:page], per_page: 20
    else
      search = '*'


      @products_all = Product.search search ,misspellings: {below: 2}, where: {published: @active, id: @products_all.map(&:id) }, page: params[:page], per_page: 20

    end

    @title = @title + ' conteniendo ' + params[:search].to_s
    # @catalogs_published = Catalog.where(published: true).order(created_at: :desc)
    # @catalogs_not_published = Catalog.where(published: false).order(created_at: :desc)
    respond_to do |format|
       format.html # index.html.erb
       format.js
    end

  end


  # GET /authors/new
  def new
    @product = Product.new
    @product.translations.build
    @title = "Nuevo producto"

    roots_and_childs


  end

  # GET /authors/1/edit
  def edit
    @title = "Editando: " + @product.name.to_s

    roots_and_childs


  end


  def create
    @title = "Nuevo producto"
    @product = Product.new(product_params)
    @product.user = current_user
    @product.categories << Category.where(id: params[:categories])
    if current_user.trust?
      @product.validated = true
    end
    respond_to do |format|
      if @product.save
        sleep(2)
        gflash :success => t('m.created_ok')
        format.html { redirect_to backend_products_path}
        #format.json { render :show, status: :created, location: @catalog }
      else
        gflash :warning => t('m.review_info')
        format.html { render :new }
        #format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @title = "Editando: " + @product.name.to_s
    respond_to do |format|
      @product.categories = []
      @product.categories << Category.where(id: params[:categories])
      if @product.update_attributes(product_params)
        gflash :success => t('m.updated_product')
        if current_user.role_admin?
          unless @product.user.trust?
            if @product.validated?
              u = @product.user
              u.trust = true
              u.save
            end
          end
        end
        sleep(2)

        format.html { redirect_to backend_products_path}
        #format.json { render :show, status: :ok, location: @catalog }
      else
        format.html { render :edit }
        #format.json { render json: @catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:validated, :published,
                                  translations_attributes: [:id,
                                                            :name,
                                                            :locale,
                                                            :description,
                                                            :keywords,
                                                            :description],
                                  product_pictures_attributes: [:id, :picture, :product_id, :order, :_destroy])
    end

end
