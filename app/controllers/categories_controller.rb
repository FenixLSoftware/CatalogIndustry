class CategoriesController < ApplicationController

  before_action :set_category, only: [:show, :subcategory, :products, :companies, :catalogs]

  def index
    @title = "Listado de categorias"

    @categories = Category.includes(:translations).all.roots.sort {|a,b| a.name <=> b.name}
    #@categories = Category.includes(:translations).roots.order(name: :asc).uniq

  end

  def show

    @title = @category.name

  end

  def subcategory

  end

  def list
    if params[:cat].present?
      @dos = Category.includes(:translations).where(ancestry: params[:cat]).sort {|a,b| a.name <=> b.name}
      @donts = Category.includes(:translations).where.not(ancestry: params[:cat]).sort {|a,b| a.name <=> b.name}


    end

  end

  def products
    if params[:sort].present?
      ids = [0]
      ids = ids +  @category.all_products.with_translations(I18n.available_locales).map{|x| [x.id, x.name.upcase] }.sort_by{ |z| z[1]}.map{|y| y[0]}
      @products = Product.includes(:translations).visible_front.where(id: ids).order( "field(id,#{ids.join(',')})" ).paginate(:page => params[:page], :per_page => 16)



      #@products = @category.all_products.includes(:translations).visible_front.with_locales(I18n.available_locales).order('product_translations.name ASC').paginate(:page => params[:page], :per_page => 16)
    else
      @products = @category.all_products.includes(:translations).visible_front.order(created_at: :desc).paginate(:page => params[:page], :per_page => 16)
    end
    render '/products/index'
  end

  def companies
    if params[:sort].present?
      #cebolla
      #@companies = @category.all_companies.role_company.visible_front.with_translations(I18n.available_locales).order(company_name: :asc).paginate(:page => params[:page], :per_page => 16) #.includes(:translations).visible_front.order(company_name: :asc).paginate(:page => params[:page], :per_page => 16)
      #@companies = User.visible_front.role_company.with_translations(I18n.available_locales).order(company_name: :asc).paginate(:page => params[:page], :per_page => 16)
      @companies = User.visible_front.role_company.with_translations(I18n.available_locales).where(id: @category.all_companies.map(&:id)).order(company_name: :asc).paginate(:page => params[:page], :per_page => 16)

    else
      @companies = @category.all_companies.includes(:translations).visible_front.order(created_at: :desc).paginate(:page => params[:page], :per_page => 16)
    end
    render '/users/index'
  end

  def catalogs

    @title = "Catalogos en la categoría " + @category.name

    if params[:sort].present?

      ids = [0]
      ids = ids + @category.all_catalogs.with_translations(I18n.available_locales).map{|x| [x.id, x.name.upcase] }.sort_by{ |z| z[1]}.map{|y| y[0]}
      @catalogs = Catalog.includes(:translations).visible_front.where(id: ids).order( "field(id,#{ids.join(',')})" ).paginate(:page => params[:page], :per_page => 16)

#      @catalogs = Catalog.where(category: @category).includes(:translations).visible_front.with_locales(I18n.available_locales).order('catalog_translations.name ASC').paginate(:page => params[:page], :per_page => 16)
      #@catalogs = @category.all_catalogs.includes(:translations).visible_front.with_locales(I18n.available_locales).order('catalog_translations.name ASC').paginate(:page => params[:page], :per_page => 16)
    else

      @catalogs = @category.all_catalogs.includes(:translations).visible_front.order(created_at: :desc).paginate(:page => params[:page], :per_page => 16)

    end

    render '/catalogs/index'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category

      @category = Category.friendly.find(params[:id])
    end

end
