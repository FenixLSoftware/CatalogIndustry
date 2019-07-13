class ProductsController < ApplicationController


  before_action :set_product, only: [:like, :show]


  def like
    if current_user.present?
      current_user.toggle_like!(@product)

      if current_user.likes?(@catalog)
        gflash :success => t('m.product_favorite')
      else
        gflash :success => t('m.product_no_favorite')
      end

      redirect_to product_path(@product)#, flash: {notice: current_user.likes?(@product) ? "El producto es uno de tus favoritos" : 'Ya no es un favorito' }

    else
      redirect_to root_path, notice: 'Debes logarte'
    end

  end


  def index
    @title = "Todas los productos"
    if params[:sort]=='1'
      ids = [0]
      ids = ids + Product.with_translations(I18n.available_locales).map{|x| [x.id, x.name.to_s.upcase] }.sort_by{ |z| z[1]}.map{|y| y[0]}
      @products = Product.includes(:translations).visible_front.where(id: ids).order( "field(id,#{ids.join(',')})" ).paginate(:page => params[:page], :per_page => 16)


      #@products = Product.includes(:translations).visible_front.order(name: :asc).paginate(:page => params[:page], :per_page => 16)
    else
      @products = Product.includes(:translations).visible_front.order(created_at: :desc).paginate(:page => params[:page], :per_page => 16)
    end

  end

  def show
    impressionist(@product, @product.user.id.to_s, :unique => [:session_hash])
    #register_visit((current_user.present? ? current_user : nil), 'P', @product.id, @product.user.id)
    @title = @product.name

  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.friendly.find(params[:id])
  end
end
