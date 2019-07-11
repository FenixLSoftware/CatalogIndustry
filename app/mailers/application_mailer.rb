class ApplicationMailer < ActionMailer::Base
  default from: 'Support Catalogindustry<support@catalogindustry.com>'
  layout 'mailer'

  def test
    @user = 'Carlos garcia de la Barrera'
    mail(to: 'cgarciabarrera@gmail.com',
         subject: 'Hi there!', bcc: ['cgarciabarrera@gmail.com', 'carlos.garcia@digital55.com'])
  end

  def just_register(user)
    @user = user
    mail(to: @user.email, subject: 'Bienvenido a CatalogIndustry', bcc: ['info@catalogindustry.com'])
  end

  def newsletter_subcribe(user_email)
    @user = user_email
    mail(to: @user, subject: 'Subscripción a newsletter')

  end

  def search_update(user, search)
    @user = user
    @search = search
    mail(to: user.email, subject: 'Novedades en su busqueda')
  end

  def contact_to_catalog(user, information)
    @user = user
    @info = information
    mail(to: user.email, subject: '[CatalogIndustry] Petición de información.', bcc: ['info@catalogindustry.com'])
  end

  def receipt_contact_to_catalog(information)

    @info = information
    mail(to: @info.email, subject: 'CatalogIndustry - Confirmación de petición de información', bcc: ['info@catalogindustry.com'])
  end

  def enquire_information_from_company(user, information)
    @user = user
    @info = information
    mail(to: user.email, subject: '[CatalogIndustry] Petición de información.', bcc: ['info@catalogindustry.com'])
  end

  def company_validated(user)
    @user = user
    mail(to: @user.email, subject: '[CatalogIndustry] Compañia validada.', bcc: ['cgarciabarrera@gmail.com', 'info@catalogindustry.com'])

  end

  def enquire_information_from_catalog(user, information, catalog)
    @user = user
    @info = information
    @catalog = catalog
    mail(to: user.email, subject: '[CatalogIndustry] Petición de información sobre catálogo.', bcc: ['info@catalogindustry.com'])
  end

  def enquire_information_from_product(user, information, product)
    @user = user
    @info = information
    @product = product
    mail(to: user.email, subject: '[CatalogIndustry] Petición de información sobre producto', bcc: ['info@catalogindustry.com'])
  end

  def receipt_enquire_information_from_company(user, information)
    @user = user
    @info = information
    mail(to: @info.email, subject: '[CatalogIndustry] Petición de información.', bcc: ['info@catalogindustry.com'])
  end

  def receipt_enquire_information_from_catalog(information, catalog)

    @info = information
    @catalog = catalog
    mail(to: @info.email, subject: 'CatalogIndustry - Confirmación de petición de contacto', bcc: ['info@catalogindustry.com'])
  end

  def receipt_enquire_information_from_product(information, product)
    @info = information
    @product = product
    mail(to: @info.email, subject: 'CatalogIndustry - Confirmación de petición de contacto', bcc: ['info@catalogindustry.com'])
  end


  private

  def final_user(user)
    if Rails.env == 'development'

    end


  end
end
