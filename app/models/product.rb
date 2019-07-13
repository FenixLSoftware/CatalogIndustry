class Product < ApplicationRecord

  belongs_to :user

  has_many :product_categories, dependent: :delete_all
  has_many :categories, through: :product_categories

  translates :name, :description, :keywords, :slug, :fallbacks_for_empty_translations => true, touch: true
  extend FriendlyId
  friendly_id :name, :use => :globalize

  has_many :product_pictures

  acts_as_likeable

  accepts_nested_attributes_for :translations
  accepts_nested_attributes_for :product_pictures, reject_if: :all_blank, allow_destroy: true

  scope :visible, -> { where(published: true) }
  scope :visible_front, -> { where(published: true, validated: true)}
  is_impressionable

  searchkick index_name: 'catalog_product' + (Rails.env == 'staging' ? '_staging' : ''), word_middle: [:company, :name, :description, :keywords, :category]

  def search_data
    {
        id: id,
        created_at: created_at,
        published: published,
        company: user.company_name.to_s,
        name: translations.map(&:name),
        description: translations.map(&:description),
        keywords: translations.map(&:keywords),
        category: categories.map{|x| x.translations.map(&:name)},
        publication_date: created_at,
        validated: validated
    }
  end

  def first_picture
    if self.product_pictures.present?
      self.product_pictures.first.picture.url
    else
      "/images/fallback/gear.jpg"
    end
  end

end
