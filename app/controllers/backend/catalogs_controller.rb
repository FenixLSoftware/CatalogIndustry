class Backend::CatalogsController < Backend::AdminController

  before_action :set_catalog, only: [:like, :show, :edit, :update, :destroy, :remove_pdf]

  def search
    index
    render 'index'
  end

  def destroy
    if @catalog.user == current_user || current_user.role_admin?
      @catalog.destroy
      gflash :success => t('m.deleted_catalog')
      redirect_to backend_catalogs_path
    else
      redirect_to backend_catalogs_path
    end

  end

  def remove_pdf

    I18n.locale = params[:locale_pdf].to_sym
    @catalog.first_page_picture = nil
    @catalog.remove_first_page_picture!
    @catalog.save
    @catalog.pdf = nil
    @catalog.remove_pdf!
    @catalog.save
    @catalog.pages.where(language: params[:locale_pdf].to_s).destroy_all
    @catalog.save
    #I18n.locale = orig_locale
    redirect_to edit_backend_catalog_path(@catalog)
  end

  def index

    if current_user.role_admin?

      @catalogs_all = Catalog.all

    else

      @catalogs_all = Catalog.where(user: current_user).order(created_at: :desc)
      # @catalogs_published = Catalog.where(user: current_user).where(published: true).order(created_at: :desc)
      # @catalogs_not_published = Catalog.where(user: current_user).where(published: false).order(created_at: :desc)

    end

    @title = "Todos los catalogos"

    @all = true
    @active = [true, false]
    if params['active']=='1'
      @catalogs_all = @catalogs_all.where(published: true)
      @all = false
      @active = true

      @title = "Catalogos activos"
    end

    if params['active']=='0'
      @catalogs_all = @catalogs_all.where(published: false)
      @all = false
      @active = false
      @title = "Catalogos inactivos"
    end

    if params['search'].present?
      search = params[:search]
      @catalogs_all = Catalog.search search ,misspellings: {below: 2}, where: {published: @active, id: @catalogs_all.map(&:id) }, page: params[:page], per_page: 20
    else
      search = '*'
      @catalogs_all = Catalog.search search ,misspellings: {below: 2}, where: {published: @active, id: @catalogs_all.map(&:id) }, order: {created_at: :desc}, page: params[:page], per_page: 20
    end

    @title = @title + ' conteniendo ' + params[:search].to_s

    #if params[:search].present?
    #  @catalogs_all = @catalogs_all.with_translations.where("name LIKE (?) OR description LIKE (?)", "%#{params[:search]}%", "%#{params[:search]}%")
    #  @title = @title + ' conteniendo ' + params[:search].to_s
    #end

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


    roots_and_childs



  end

  # GET /authors/1/edit
  def edit
    @title = "Editando: " + @catalog.name.to_s
    roots_and_childs
  end


  def create
    @title = "Nuevo catálogo"

    @catalog = Catalog.new(catalog_params)
    @catalog.user = current_user
    @catalog.categories = []
    @catalog.categories << Category.where(id: params[:categories])
    if current_user.trust?
      @catalog.validated = true
    end

    respond_to do |format|
      if @catalog.save

        # recalcular slugs

        I18n.available_locales.each do |l|
          I18n.locale = l
          if @catalog.slug.to_s.size == 36
            @catalog.slug = @catalog.name.parameterize + '-' + rand(200000).to_s
            @catalog.save
          end
        end

        process_pdf(catalog_params, @catalog)
        sleep(2)
        gflash :success => t('m.created_ok')
        format.html {redirect_to backend_catalogs_path}
        #format.json { render :show, status: :created, location: @catalog }
      else
        gflash :warning => t('m.review_info')
        format.html {render :new}
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
        #pasar cada idioma de pdf si han cambiado y procesarlos

        #:es, :en, :fr, :de, :it, :zh

        process_pdf(catalog_params, @catalog)
        sleep(2)
        if current_user.role_admin?
          unless @catalog.user.trust?
            if @catalog.validated?
              u = @catalog.user
              u.trust = true
              u.save
            end
          end
        end

        # recalcular slugs

        I18n.available_locales.each do |l|
          I18n.locale = l
          if @catalog.slug.to_s.size == 36
            @catalog.slug = @catalog.name.parameterize + '-' + rand(200000).to_s
            @catalog.save
          end
        end
        gflash :success => t('m.updated_catalog')
        format.html {redirect_to backend_catalogs_path}
        #format.json { render :show, status: :ok, location: @catalog }
      else
        format.html {render :edit}
        #format.json { render json: @catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def process_pdf(catalog_params, catalog)

    if catalog_params[:pdf_es].present?
      I18n.locale = :es
      catalog.pdf = catalog_params[:pdf_es]
      catalog.save
      Catalog.delay.extract_pages(catalog, catalog.pdf.path, :es)
    end
    if catalog_params[:pdf_en].present?
      I18n.locale = :en
      catalog.pdf = catalog_params[:pdf_en]
      catalog.save
      Catalog.delay.extract_pages(catalog, catalog.pdf.path, :en)
    end
    if catalog_params[:pdf_fr].present?
      I18n.locale = :fr
      catalog.pdf = catalog_params[:pdf_fr]
      catalog.save
      Catalog.delay.extract_pages(catalog, catalog.pdf.path, :fr)
    end
    if catalog_params[:pdf_de].present?
      I18n.locale = :de
      catalog.pdf = catalog_params[:pdf_de]
      catalog.save
      Catalog.delay.extract_pages(catalog, catalog.pdf.path, :de)
    end
    if catalog_params[:pdf_it].present?
      I18n.locale = :it
      catalog.pdf = catalog_params[:pdf_it]
      catalog.save
      Catalog.delay.extract_pages(catalog, catalog.pdf.path, :it)
    end
    if catalog_params[:pdf_zh].present?
      I18n.locale = :zh
      @catalog.pdf = catalog_params[:pdf_zh]
      @catalog.save
      Catalog.delay.extract_pages(catalog, catalog.pdf.path, :zh)
    end


  end


  # Use callbacks to share common setup or constraints between actions.
  def set_catalog
    @catalog = Catalog.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def catalog_params
    params.require(:catalog).permit(:validated, :published, :pdf_es, :pdf_en, :pdf_fr, :pdf_de, :pdf_it, :pdf_zh,
                                    translations_attributes: [:id,
                                                              :name,
                                                              :locale,
                                                              :description,
                                                              :keywords,
                                                              :description])
  end

end
