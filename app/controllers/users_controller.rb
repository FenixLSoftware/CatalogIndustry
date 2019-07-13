class UsersController < ApplicationController
  before_action :set_company, only: [:menu_catalog, :menu_product, :menu_new, :like, :show]




  def like
    if current_user.present?
      current_user.toggle_like!(@company)
      if current_user.likes?(@company)
        gflash :success => t('m.company_favorite')
      else
        gflash :success => t('m.company_no_favorite')
      end
      redirect_to :back#, flash: {notice: current_user.likes?(@company) ?  : 'Ya no es un favorito' }

    else
      redirect_to root_path, notice: 'Debes logarte'
    end

  end



  def index

    @title = "Todas las empresas"
    if params[:sort]=='1'
      @companies = User.visible_front.role_company.with_translations(I18n.available_locales).order(company_name: :asc).paginate(:page => params[:page], :per_page => 16)
    else
      @companies = User.visible_front.role_company.with_translations(I18n.available_locales).order(created_at: :desc).paginate(:page => params[:page], :per_page => 16)
    end
  end

  def send_to_newsletter
    if params[:email].present?
      resp = User.add_to_newsletter(params[:email])
      ApplicationMailer.newsletter_subcribe(params[:email]).deliver
      gflash :success => t('m.newsletter_subscribed')
    else

    end
    redirect_to :back
  end

  def show
    impressionist(@company, @company.id.to_s, :unique => [:session_hash])
    #register_visit((current_user.present? ? current_user : nil), 'U', @company.id, @company.id)
    @title = @company.company_name

  end


  def menu_catalog
    @catalogs = @company.catalogs.visible_front.order(created_at: :desc)#.paginate(:page => params[:page], :per_page => 8)

  end

  def menu_product
    @products = @company.products.visible_front.order(created_at: :desc)#.paginate(:page => params[:page], :per_page => 8)

  end

  def menu_new
    @news = @company.posts.visible_front.order(created_at: :desc)#.paginate(:page => params[:page], :per_page => 8)

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = User.friendly.find(params[:id])
    if @company.present?
      if @company.validated == false
        redirect_to root_path
      end
    end
  end

end
