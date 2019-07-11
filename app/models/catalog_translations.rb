class CatalogTranslations < ActiveRecord::Base
extend CarrierwaveGlobalize

mount_translated_uploader :pdf, CatalogpdfUploader
end
