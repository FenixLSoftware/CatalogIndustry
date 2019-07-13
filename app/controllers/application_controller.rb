class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  layout 'frontend/application_front'

  before_action :store_user_location!, if: :storable_location?

  http_basic_authenticate_with :name => "catalog", :password => "Catalog01" if Rails.env=='staging'

  include ApplicationHelper

  after_filter :store_location



  def default_url_options
    #unless params['controller'].starts_with?('backend')
      {locale: I18n.locale}
    #else
    #  {}
    #end
  end


  def roots_and_childs

    @roots = []
    @childs = []

    Category.includes(:translations).all.roots.sort {|a,b| a.name <=> b.name}.each do |root_cat|
      if root_cat.children.present?
        @roots << [root_cat.name, root_cat.id]
      end
   end

    Category.includes(:translations).all.sort {|a,b| a.name <=> b.name}.each do |cat|
      unless cat.root?
        @childs << [cat.name, cat.id]
      end
   end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end


  private

  def set_locale
    if session[:current_locale] == nil
      session[:current_locale] = I18n.default_locale
    end
    I18n.locale = session[:current_locale]

    if params[:locale].present?
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale].to_sym
        session[:current_locale] = I18n.locale
      end
    end
  end


  # Its important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an
  #    infinite redirect loop.
  # - The request is an Ajax request as this can lead to very unexpected behaviour.
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end


  def store_location
    # store last url as long as it isn't a /users path

    if devise_controller? || request.xhr? || request.fullpath.include?('/register')

    else
      session[:previous_url] = request.fullpath
    end
    #session[:previous_url] = request.fullpath unless (!devise_controller? || !request.xhr?)
    # p'********************************+'
    # p session[:previous_url]
    # p'********************************+'
  end

end
