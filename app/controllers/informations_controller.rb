class InformationsController < ApplicationController

  def enquire

    if verify_recaptcha secret_key: Rails.application.secrets.recaptcha_secret_key
      user_dest = User.find_by_id(params[:user_id])

      if user_dest.present?
        i = Information.new
        i.user = user_dest
        i.name = params[:name]
        i.company = params[:company]
        i.email = params[:email]
        i.phone = params[:phone]
        i.city = params[:city]
        i.country = params[:country]
        i.comment = params[:message]
        if i.valid?
          i.save
          if params[:item] == 'e' #empresa
            ApplicationMailer.enquire_information_from_company(user_dest, i).deliver
            ApplicationMailer.receipt_enquire_information_from_company(user_dest, i).deliver
          end
          if params[:item] == 'c' #catalogo
            ApplicationMailer.enquire_information_from_catalog(user_dest, i,
              Catalog.find(params[:item_id])).deliver
            ApplicationMailer.receipt_enquire_information_from_catalog(i,
              Catalog.find(params[:item_id])).deliver
          end
          if params[:item] == 'p' #producto
            ApplicationMailer.enquire_information_from_product(user_dest, i,
              Product.find(params[:item_id])).deliver
            ApplicationMailer.receipt_enquire_information_from_product(i,
              Product.find(params[:item_id])).deliver
          end
        end
        gflash :success => t('m.contact_sent')
        session[:event_contact] = 'OK'
        redirect_to :back #, notice: 'Petición de contacto enviada'
      else
        redirect_to :back
      end
    else
        gflash :error => t('m.recaptcha')
        redirect_to :back #, notice: 'Petición de contacto enviada'
    end
  end
end
