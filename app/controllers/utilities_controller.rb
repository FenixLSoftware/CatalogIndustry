class UtilitiesController < ApplicationController
include ApplicationHelper

def switch_locale



  change_locale(params[:locale_new].to_sym)
  I18n.locale = params[:locale_new].to_sym
  url_hash = Rails.application.routes.recognize_path URI(request.referer).path
  url_hash[:locale] = params[:locale_new]
  redirect_to url_hash
  #redirect_to :back, locale: params[:locale_new].to_sym

end

end

