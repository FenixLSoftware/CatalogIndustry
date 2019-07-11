class Page < ApplicationRecord

  belongs_to :catalog

  mount_uploader :page, PagepageUploader

end
