module ApplicationHelper

  def change_locale(locale)

    I18n.locale = locale
    session[:current_locale] = I18n.locale

  end


  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def credit_card_expiration(user)
    # 0 si OK, 1 si caduca este mes, 2 si caducada
    ret_val = 0
    expires = Date.civil(user.stripe_year.to_i, user.stripe_month.to_i, -1).to_date
    dif = (expires - Time.current.to_date).to_i
    case
    when dif >= 0 && dif < 30
      ret_val = 1
    when dif < 0
      ret_val = 2
    when dif >= 30
      ret_val = 0
    end
    ret_val
  end


  # def register_visit(visiter_object, object_type, object_id, owner_id)
  #   v = Visit.new
  #   v.anonymous = true if visiter_object.nil?
  #   visiter_object.present? ? (v.user_id = visiter_object.id) : nil
  #   v.element_id = object_id
  #   v.element_type = object_type
  #   v.company_id =owner_id
  #   v.save
  # end

end
