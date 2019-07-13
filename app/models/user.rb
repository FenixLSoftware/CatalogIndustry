class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: %i[linkedin]

  enum role: [:role_admin, :role_company, :role_professional, :role_visitor]

  attr_accessor :pw_a, :pw_n, :card_name, :card_number, :card_month, :card_year, :card_cvv

  has_many :catalogs, dependent: :destroy
  has_many :informations, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :payments, dependent: :destroy

  has_many :searches, dependent: :destroy

  acts_as_liker
  acts_as_likeable

  translates :description, :fallbacks_for_empty_translations => true, touch: true
  extend FriendlyId
  friendly_id :company_name, use: :slugged

  accepts_nested_attributes_for :translations

  mount_uploader :logo, UserlogoUploader
  mount_uploader :company_picture, UsercompanypictureUploader

  after_initialize :set_default_role, :if => :new_record?

  scope :visible_front, -> {where(validated: true)}

  is_impressionable

  searchkick index_name: 'catalog_user' + (Rails.env == 'staging' ? '_staging' : ''), word_middle: [:company_name, :city, :country, :phone, :address]

  def self.add_to_newsletter(user_email)
    require 'oauth'
    consumer = OAuth::Consumer.new '3734', 'i6IXULMb6C1EDHofq4Wp', { site: 'http://www.mdirector.com' }
    access_token = OAuth::AccessToken.new(consumer)
    access_token.post('/api_contact', { 'email' => user_email })
  end

  def search_data
    {
        id: id,
        created_at: created_at,
        professional_name: name,
        name: company_name,
        address: address,
        city: city,
        country: country,
        publication_date: created_at,
        validated: validated,
        description: translations.map(&:description),
        phone: phone,
        role: role
    }
  end

  def can_upload(kind)
    can = false
    if kind == 'c'
      can = true if catalogs.size.zero?
    end

    if kind == 'p'
      can = true if products.size.zero?
    end

    if kind == 'n'
      can = true if posts.size.zero?
    end

    can = payment_valid if can == false

    can
  end

  def payment_valid #SI TRUE AUN PUEDE SUBIR, ES LO QUE DETERMINA SI PUEDE SUBIR. SOLO ESTO.
      #ver si hay pagos validados
      can = false
      last_p = self.payments.order(created_at: :desc).first

      if last_p.present?
        if last_p.next_payment > Time.now
          can = true
        else
          can = false
        end
      else
        can = false
      end
      can
  end

  def is_premium?
      payment_valid
      #false
    # pago hecho y no caducado
    # if payments.present?
    #   all_payments = payments.where(success: true).order(created_at: :desc)
    #   if all_payments.present?

    #   else
    #     false
    #   end
    # else
    #   false
    # end
  end


  def save_search(search)
    @products = Product.search search, where: {published: true, validated: true}
    @catalogs = Catalog.search search, where: {published: true, validated: true}
    @categories = Category.search search, where: {is_root: false}
    @posts = Post.search search, where: {published: true, validated: true}
    s = Search.new(term: search)
    s.products = @products.map(&:id).join(',')
    s.catalogs = @catalogs.map(&:id).join(',')
    s.posts = @posts.map(&:id).join(',')
    self.searches << s
    #grabar el resultado de la busqueda



  end

  def set_default_role
    self.role ||= :role_professional #:role_company
    self.validated = false
  end

  def remove_stripe
    cu = Stripe::Customer.retrieve(stripe_id)
    cu.delete if cu.present?
  end

  def send_to_stripe
    stripe_obj = Stripe::Customer.create(description: (Rails.env == 'production' ? '' : 'dev_') + name)

    p stripe_obj.id

    update_attribute(:stripe_id, stripe_obj.id)

  end

  def country_name
    country_x = ISO3166::Country[country]
    country_x.name
  end

  def assign_card(number, month, year, cvc, name_in_card = 'demo name')
    customer = Stripe::Customer.retrieve(stripe_id)
    # borramos la que haya
    actual_card = stripe_card_id
    source = { object: 'card', name: name_in_card, number: number,
               exp_month: month, exp_year: year, cvc: cvc }
    begin
      tok = customer.sources.create(source: source)
      update_attributes(stripe_name_card: tok.name, stripe_card_id: tok.id,
                        stripe_month: tok.exp_month,
                        stripe_year: tok.exp_year, stripe_brand: tok.brand,
                        stripe_last4: tok.last4)
      # si todo fue ok, borramos la visa anterior de stripe, si la habia
      # asi queda por defecto la nueva
      customer.sources.retrieve(actual_card).delete if actual_card.present?
    rescue => error
      error
    end
  end

  def assign_demo_credit_card
    assign_card(Rails.application.secrets.number,
                Rails.application.secrets.month,
                Rails.application.secrets.year,
                Rails.application.secrets.cvv)
  end

  def charge_amount(amount, currency, description)
    card_info = stripe_brand.to_s + " (xxxx-xxxx-xxxx-" + stripe_last4.to_s + ") exp: " + stripe_month + "/" + stripe_year + " : " + stripe_name_card
    begin
      charge = Stripe::Charge.create(amount: amount, currency: currency.downcase, customer: Stripe::Customer.retrieve(stripe_id), description: description)
      Payment.create(card_info: card_info  ,next_payment: (Time.now + 1.month), user: self, success: (charge.status == 'succeeded' ? true : false), response: charge, amount: charge.amount)
    rescue Stripe::CardError, Stripe::InvalidRequestError => e

      Payment.create(card_info: card_info  ,next_payment: (Time.now), user: self, success: false, response: e.message, amount: amount)
      return { status: false, error: e.message, charge: nil, error_code: e.code }
    end

    { status: true, error: nil, charge: charge }
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.address = auth.info.location
      user.phone = auth.info.phone
      user.linkedin_url = auth.info.urls.public_profile
      user.password = Devise.friendly_token[0, 128]
    end
  end

  def self.process_payments
    User.role_company.where(current_plan: 1).each do |u|
      if u.stripe_card_id.present?
        # solo si tienen tarjeta
        unless u.payment_valid
          resp = u.charge_amount(12098, 'eur', 'Fee CatalogIndustry.com')
          if resp[:status]
            # pago ok
            u.current_plan = 1
          else
            # pago con error
            u.current_plan = 0
          end
          u.save
        end

      end
    end
  end


end
