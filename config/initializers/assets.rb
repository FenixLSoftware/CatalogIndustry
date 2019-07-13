# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( frontend/all.scss )
Rails.application.config.assets.precompile += %w( frontend/all.js )

Rails.application.config.assets.precompile += %w( backend/all.scss )
Rails.application.config.assets.precompile += %w( backend/all.js )

Rails.application.config.assets.precompile += %w( jquery.mousewheel.min.js )
Rails.application.config.assets.precompile += %w( three.min.js )
Rails.application.config.assets.precompile += %w( jquery.onebook3d-2.33.js )
Rails.application.config.assets.precompile += %w( jquery-3.1.1.min.js )
Rails.application.config.assets.precompile += %w( jquery-1.11.0.min.js )
Rails.application.config.assets.precompile += %w( ckeditor/* )
Rails.application.config.assets.precompile += %w( backend/ckeditor/ckeditor_config.js)

Rails.application.config.assets.precompile += %w( jquery.validate.localization/messages_es.js )
Rails.application.config.assets.precompile += %w( jquery.validate.localization/messages_de.js )
Rails.application.config.assets.precompile += %w( jquery.validate.localization/messages_fr.js )
Rails.application.config.assets.precompile += %w( jquery.validate.localization/messages_it.js )
Rails.application.config.assets.precompile += %w( jquery.validate.localization/messages_zh.js )
