class Carousel < ApplicationRecord

	 #belongs_to :user

  translates :title, :description, :slug, :fallbacks_for_empty_translations => true, touch: true
  extend FriendlyId
 	friendly_id :title, :use => :globalize

  mount_uploader :picture, CarouselUploader
  accepts_nested_attributes_for :translations

  scope :visible, -> { where(published: true)}#.where.not(user: [nil, ""]) }
  is_impressionable
   def search_data
    {
        published: published,
        title: translations.map(&:title),
        description: translations.map(&:description),
        publication_date: created_at
    }
  end
end


