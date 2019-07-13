class Post < ApplicationRecord

  belongs_to :user

  translates :title, :description, :slug, :fallbacks_for_empty_translations => true, touch: true
  extend FriendlyId
  friendly_id :title, :use => :globalize

  mount_uploader :picture, PostpictureUploader
  accepts_nested_attributes_for :translations

  acts_as_likeable

  scope :visible, -> { where(published: true)}#.where.not(user: [nil, ""]) }
  scope :visible_front, -> { where(published: true, validated: true)}
  is_impressionable

  searchkick index_name: 'catalog_post' + (Rails.env == 'staging' ? '_staging' : ''), word_middle: [:company, :title, :description]

  def search_data
    {
        id: id,
        created_at: created_at,
        published: published,
        company: user.company_name.to_s,
        name: translations.map(&:title),
        description: translations.map(&:description),
        publication_date: created_at,
        validated: validated
    }
  end
end
