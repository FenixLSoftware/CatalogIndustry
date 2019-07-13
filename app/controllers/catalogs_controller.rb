class CatalogsController < ApplicationController


  before_action :set_catalog, only: [:view_online, :like, :show, :get_pdf]

  #impressionist :actions=>[:show]

  def like
    if current_user.present?

      current_user.toggle_like!(@catalog)
      if current_user.likes?(@catalog)
        gflash :success => t('m.catalog_favorite')
      else
        gflash :success => t('m.catalog_no_favorite')
      end
      #gflash success:  current_user.likes?(@catalog) ? "El catalogo es uno de tus favoritos" : 'Ya no es un favorito'
      #gflash :error => { :value => "Custom error", :time => 3000, :class_name => "my_error_class", :sticky => false }
      #gflash :notice, :success, :error
      redirect_to catalog_path(@catalog)#, :gflash => { :warning => "You just deleted something important." }

    else
      redirect_to root_path, notice: 'Debes logarte'
    end

  end

  def view_online
    impressionist(@catalog, @catalog.user.id.to_s, :unique => [:session_hash])

    @title = @catalog.name
    # para saber el idioma de las páginas segun fallback y
    if params[:version].present?
      @pages = @catalog.pages.where(language: params[:version]).order(page_number: :asc)
    else
      I18n.fallbacks[I18n.locale].each do |lng|
        @pages = @catalog.pages.where(language: lng.to_s).order(page_number: :asc)
        if @pages.present?
          break
        end
      end
    end
  end

  def index

    @title = "Todos los catálogos"
    if params[:sort]=='1'

      ids = [0]
      ids = ids + Catalog.with_translations(I18n.available_locales).map{|x| [x.id, x.name.to_s.upcase] }.sort_by{ |z| z[1]}.map{|y| y[0]}
      @catalogs = Catalog.includes(:translations).visible_front.where(id: ids).order( "field(id,#{ids.join(',')})" ).paginate(:page => params[:page], :per_page => 16)
      #@catalogs = Catalog.includes(:translations).with_locales(I18n.locale).order('catalog_translations.name ASC').visible_front.paginate(:page => params[:page], :per_page => 16)
      #@catalogs = Catalog.includes(:translations).visible_front.order(name: :asc).paginate(:page => params[:page], :per_page => 16)
    else
      @catalogs = Catalog.includes(:translations).visible_front.order(created_at: :desc).paginate(:page => params[:page], :per_page => 16)
    end

  end

  def show

    #register_visit((current_user.present? ? current_user : nil), 'C', @catalog.id, @catalog.user.id)

    impressionist(@catalog, @catalog.user.id.to_s, :unique => [:session_hash])

    @title = @catalog.name
    # para saber el idioma de las páginas segun fallback y
    if params[:version].present?
      @pages = @catalog.pages.where(language: params[:version]).order(page_number: :asc)
    else
      I18n.fallbacks[I18n.locale].each do |lng|
        @pages = @catalog.pages.where(language: lng.to_s).order(page_number: :asc)
        if @pages.present?
          break
        end
      end
    end

  end

  def get_pdf
    if params[:locale_pdf].present?
      I18n.locale = params[:locale_pdf].to_sym
      send_file @catalog.pdf.path, :filename => @catalog.slug + '.pdf'
    else
      send_file @catalog.pdf.path, :filename => @catalog.slug + '.pdf'
    end
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_catalog
    @catalog = Catalog.friendly.find(params[:id])
    #if @catalog.present? && @catalog.user == current_user || current_user.role_admin?
    #end
  end
end
