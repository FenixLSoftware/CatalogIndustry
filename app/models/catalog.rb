class Catalog < ApplicationRecord
  extend CarrierwaveGlobalize

  attr_accessor :pdf_es, :pdf_en, :pdf_it, :pdf_fr, :pdf_de, :pdf_zh

  belongs_to :user

  has_many :catalog_categories, dependent: :delete_all
  has_many :categories, through: :catalog_categories

  accepts_nested_attributes_for :categories, reject_if: :all_blank

  has_many :pages, dependent: :destroy

  translates :name, fallbacks_for_empty_translations: true
  translates :description, fallbacks_for_empty_translations: true
  translates :keywords, fallbacks_for_empty_translations: true
  translates :slug, fallbacks_for_empty_translations: true
  translates :pdf, fallbacks_for_empty_translations: true
  translates :first_page_picture, fallbacks_for_empty_translations: true

  extend FriendlyId
  friendly_id :name, :use => :globalize

  #globalize_accessors  :attributes => [:name, :description, :keywords, :slug]

  acts_as_likeable

  accepts_nested_attributes_for :translations

  mount_translated_uploader :first_page_picture, CatalogfistpagepictureUploader
  #mount_uploader :pdf, CatalogpdfUploader
  mount_translated_uploader :pdf, CatalogpdfUploader


  #validates :pdf, presence: true

  scope :visible, -> { where(published: true)}#.where.not(user: [nil, ""]) }
  scope :visible_front, -> { where(published: true, validated: true)}#.where.not(user: [nil, ""]) }
  # pdf   = Grim.reap("billy.pdf")
  # pdf[8].save('billy8.jpeg', {:alpha => 'Activate', :colorspace => "CMYK", :width => 300})

  is_impressionable

  searchkick index_name: 'catalog_catalog' + (Rails.env == 'staging' ? '_staging' : ''), word_middle: [:company, :name, :description, :keywords, :category]

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

  def self.extract_pages(catalog, file, locale)

    #borrar las paginas de ese idioma
    catalog.pages.where(language: locale.to_s).destroy_all
    #abrir el pdf con grim
    pdf   = Grim.reap(file)

    pdf.each_with_index do |page, idx|
      # solo las 1000? (todas) primeras paginas de cada catálogo
      if idx < 1000
        catalog.reload

        temp_file = "tmp/" + SecureRandom.uuid + '.jpg'
        page.save(temp_file, {:alpha => 'Activate', :colorspace => "CMYK", :width => 900})
        p = Page.new
        p.language = locale.to_s
        p.page_number = idx
        p.page = Rails.root.join(temp_file).open
        catalog.pages << p
        if idx == 0
          I18n.locale = locale
          catalog.first_page_picture = Rails.root.join(temp_file).open
          catalog.save
        end
        File.delete(temp_file) if File.exist?(temp_file)
      end
    end


  end
end
