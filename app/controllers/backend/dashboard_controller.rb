class Backend::DashboardController < Backend::AdminController


require 'action_view'
require 'action_view/helpers'
include ActionView::Helpers::DateHelper


  def index


    if current_user.role_admin?
      redirect_to backend_users_path
    else
      if current_user.role_professional?
        redirect_to edit_backend_user_path(current_user)
      else
        @informations = Information.where(user: current_user).order(created_at: :desc).limit(10)
        @visits = Impression.where.not(user_id: [nil,current_user.id]).where(message: current_user.id.to_s).limit(10)
        @products = Product.visible_front.where(user: current_user).order(created_at: :desc).limit(10)
        @catalogs = Catalog.visible_front.where(user: current_user).order(created_at: :desc).limit(10)
      end
    end
  end

  def activity

  end

end
