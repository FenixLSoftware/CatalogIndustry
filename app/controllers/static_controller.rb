class StaticController < ApplicationController
  def about_us
  end
  def contact
  end
  def privacy_policy
  end

  def send_contact
    if verify_recaptcha secret_key: Rails.application.secrets.recaptcha_secret_key
      i = Information.create(city: params[:city], country: params[:country],
                             company: params[:company], name: params[:name],
                             email: params[:email],
                             phone: params[:phone], user: User.role_admin.first,
                             comment: params[:message])
      ApplicationMailer.contact_to_catalog(i.user, i).deliver
      ApplicationMailer.receipt_contact_to_catalog(i).deliver

      #ApplicationMailer.enquire_informa.buttontion(User.role_admin.first, i)
      gflash :success => t('m.info_sent')
      redirect_to root_path
    else

      gflash :error => t('m.recaptcha')
      redirect_to :back
    end
  end
end
