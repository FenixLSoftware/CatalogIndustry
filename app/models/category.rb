class Category < ApplicationRecord

  translates :name, :slug, :fallbacks_for_empty_translations => true, touch: true
  extend FriendlyId
  friendly_id :name, :use => :globalize


  has_many :catalog_categories, dependent: :delete_all
  has_many :catalogs, through: :catalog_categories

  has_many :product_categories, dependent: :delete_all
  has_many :products, through: :product_categories

  mount_uploader :picture, CategorypictureUploader

  has_ancestry
  acts_as_likeable

  searchkick index_name: 'catalog_category' + (Rails.env == 'staging' ? '_staging' : ''), word_middle: [:name, :root]

  def search_data
    {
        name: translations.map(&:name),
        root: self.root.translations.map(&:name),
        is_root: self.root?
    }
  end

  def all_companies

    #las companies que tienen productos o catalogos en esa categoria
    companies = []
    self.all_catalogs.each do |catalog|
      companies << catalog.user.id if catalog.user.present?
    end
    self.all_products.each do |product|
      companies << product.user.id if product.user.present?
    end
    User.where(id: companies)
  end

  def all_products
    if self.root?
      products = []
      self.children.each do |children|
        children.products.includes(:user).each do |prod|
          products << prod.id
        end
      end
      Product.where(id: products)
    else
      self.products
    end
  end

  def all_catalogs
    if self.root?
      catalogs = []
      self.children.each do |children|
        children.catalogs.includes(:user).each do |cata|
          catalogs << cata.id
        end
      end
      Catalog.where(id: catalogs)
    else
      self.catalogs
    end
  end

end
