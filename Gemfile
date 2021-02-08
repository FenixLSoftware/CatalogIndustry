source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
ruby '2.5.3'
gem 'rails', '~> 5.0.6'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

group :development, :test do
  gem 'byebug', platform: :mri
end
group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'devise'
gem 'high_voltage'
gem 'mysql2', '~> 0.3.18'
gem 'grim'
gem 'impressionist'
gem 'searchkick'
gem 'cocoon'
gem "ckeditor"
gem 'groupdate'
gem 'stripe-rails'
gem 'rufus-scheduler'
gem 'mailcatcher'
gem 'dynamic_sitemaps'
gem "gritter", "1.2.0"
gem 'cookieconsent2-rails'
gem "recaptcha", require: "recaptcha/rails"
#lextrend

gem 'globalize', git: 'https://github.com/globalize/globalize'
gem 'activemodel-serializers-xml'

gem 'ancestry'
gem 'socialization'
gem 'carrierwave', '~> 1.3'
gem 'friendly_id'
gem 'friendly_id-globalize'
gem 'font-awesome-rails'
gem 'will_paginate', '~> 3.1.0'
gem 'rails-i18n'
gem 'globalize-accessors'
gem 'will_paginate-bootstrap'
gem "select2-rails"
gem 'viewerjs-rails'
gem 'mini_magick'
gem 'grim'
gem 'faker'
gem 'carrierwave_globalize', '~> 0.2.0'
gem 'sidekiq'
gem 'social-share-button'
gem 'jquery-validation-rails'
gem 'omniauth'
gem 'omniauth-linkedin'
gem 'country_select'
gem 'countries', require: 'countries/global'
#gem 'redis-namespace' usamos DB no namespace
gem "lol_dba"
gem 'redis-rails', '~> 5'
gem 'rack-attack'

group :development do
  gem 'airbrussh', require: false
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', github: 'capistrano/rails'
  gem 'capistrano-rails-console'
  gem 'capistrano-rvm', '~> 0.1.1'
  gem 'capistrano-sidekiq'
  gem 'rails_layout'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'thin'
end
group :production do
  gem 'unicorn'
end
group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
end

gem "rails-ujs", "~> 0.1.0"
