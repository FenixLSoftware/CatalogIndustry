class Backend::AdminController < ApplicationController
  layout 'backend/application_back'

  before_action :authenticate_user!

  before_action :has_limit_reached


  def has_limit_reached

    if current_user.present?
      if current_user.role_admin?
        @limit_reached = false
      end
      if current_user.role_professional?
        @limit_reached = false #true
      end

      if current_user.role_company?
        if current_user.catalogs.size > 1
          @limit_reached = false
        else
          @limit_reached = false
        end
      end

    else
      @limit_reached = true
    end
  end

end
