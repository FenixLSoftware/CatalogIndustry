class ProductPicture < ApplicationRecord

  belongs_to :product

  mount_uploader :picture, ProductpictureUploader
end
