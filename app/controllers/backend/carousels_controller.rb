class Backend::CarouselsController < Backend::AdminController
before_action :set_carousel, only: [:like, :show, :edit, :update, :destroy]

def search
    index
    render 'index'
  end

  def index

    if current_user.role_admin?

      @carousel_all = Carousel.all

    else

      @carousel_all = Carousel.order(created_at: :desc)
      # @catalogs_published = Catalog.where(user: current_user).where(published: true).order(created_at: :desc)
      # @catalogs_not_published = Catalog.where(user: current_user).where(published: false).order(created_at: :desc)

    end

    @title = "Todas las notas de prensa"

    @all = true
    @active = nil
    if params['active']=='1'
        @carousel_all = @carousel_all.where(published: true)
         @all = false
         @active = true

         @title = "Notas de prensa activas"
    end

    if params['active']=='0'
      @carousel_all = @carousel_all.where(published: false)
       @all = false
       @active = false
       @title = "Notas de prensa inactivas"
    end

    if params[:search].present?
      @carousel_all = @carousel_all.with_translations.where("title LIKE (?) OR description LIKE (?)", "%#{params[:search]}%", "%#{params[:search]}%")
      @title = @title + ' conteniendo ' + params[:search].to_s
    end

    if params[:search].present?
      if params[:search].size < 3

        redirect_to backend_carousels_path, notice: 'Mínimo 3 carácteres'
      else
        @carousel_all = @carousel_all.order(created_at: :desc)
      end
    else
      @carousel_all = @carousel_all.order(created_at: :desc).paginate(:page => params[:page], :per_page => 10)
    end
    # @catalogs_published = Catalog.where(published: true).order(created_at: :desc)
    # @catalogs_not_published = Catalog.where(published: false).order(created_at: :desc)
    respond_to do |format|
       format.html # index.html.erb
       format.js
    end

  end
    def set_carousel
      @carousel = Carousel.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.


  # GET /authors/new
  def new
    @carousel = Carousel.new
    @carousel.translations.build
    @title = "Nueva nota de prensa"
  end

  # GET /authors/1/edit
  def edit
    @title = "Editando: " + @carousel.title.to_s
  end


  def create
    @title = "Nueva portada"
    @carousel = Carousel.new(carousel_params)
    #@carousel.user = current_user

    respond_to do |format|
      if @carousel.save
        format.html { redirect_to backend_carousels_path, notice: t('successfully_created_record') }
        #format.json { render :show, status: :created, location: @catalog }
      else
        format.html { render :new }
        #format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @title = "Editando: " + @carousel.title.to_s
    respond_to do |format|

      if @carousel.update_attributes(carousel_params)

        format.html { redirect_to backend_carousels_path, notice: t('successfully_updated_record') }
        #format.json { render :show, status: :ok, location: @catalog }
      else
        format.html { render :edit }
        #format.json { render json: @catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carousel
      @carousel = Carousel.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def carousel_params
      params.require(:carousel).permit(:published, :picture,:url,
                                  translations_attributes: [:id,
                                                            :title,
                                                            :slug,
                                                            :locale,
                                                            :description])
    end


end

