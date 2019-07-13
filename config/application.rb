require_relative 'boot'

require 'rails/all'
#require 'i18n/backend/fallbacks'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CatalogIndustry
  class Application < Rails::Application

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: false,
                       request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.middleware.use Rack::Attack
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Europe/Madrid'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]

    config.i18n.available_locales = [:en, :es, :fr, :de, :it]
    config.i18n.fallbacks = true
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :es

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.to_prepare do
      Devise::SessionsController.layout "frontend/register"
      Devise::RegistrationsController.layout "frontend/register"#proc{ |controller| user_signed_in? ? "application" : "your_layout_name" }
      Devise::ConfirmationsController.layout "frontend/register"
      Devise::UnlocksController.layout "frontend/register"
      Devise::PasswordsController.layout "frontend/register"
    end

    config.after_initialize do
      I18n.fallbacks = {en: [:en, :es, :fr, :de, :it, :zh],
                        es: [:es, :en, :fr, :de, :it, :zh],
                        fr: [:fr, :en, :es, :de, :it, :zh],
                        de: [:de, :en, :fr, :es, :it, :zh],
                        it: [:it, :en, :fr, :de, :es, :zh]
                        }
    end
  end
end
