Rails.application.routes.draw do


  mount Sidekiq::Web => '/sidekiq'
  devise_for :users, controllers: {
      registrations: 'users/registrations',
      passwords: 'users/passwords',
      omniauth_callbacks: 'authorizations'
  }

  scope '/(:locale)', locale: /#{I18n.available_locales.join('|')}/ do

    get 'search/search', as: 'search_get'
    get 'search/save_search/:term', to: 'search#save_search', as: 'save_search_get'
    post 'search/search', as: 'search_post'

    resources :static do
      collection do
        get 'about_us', to: 'static#about_us', as: 'about_us'
        get 'faq', to: 'static#faq', as: 'faq'
        get 'contact', to: 'static#contact', as: 'contact'
        get 'privacy_policy', to: 'static#privacy_policy', as: 'privacy_policy'
        get 'legal_notice', to: 'static#legal_notice', as: 'legal_notice'
        get 'publish', to: 'static#publish', as: 'publish'
        post 'send_contact', to: 'static#send_contact', as: 'send_contact'
      end
    end
    get '/blog', to: 'blog#index', as: 'blog'

    root to: 'index#index'


    resources :users do
      member do
        get 'like', to: 'users#like', as: 'like'
        get 'menu_catalog', to: 'users#menu_catalog', as: 'menu_catalog'
        get 'menu_product', to: 'users#menu_product', as: 'menu_product'
        get 'menu_new', to: 'users#menu_new', as: 'menu_new'
      end
      collection do
        post 'send_to_newsletter', to: 'users#send_to_newsletter', as: 'send_to_newsletter'
      end

    end

    resources :catalogs do
      member do
        get 'like', to: 'catalogs#like', as: 'like'
        get 'view_online', to: 'catalogs#view_online', as: 'view_online'
        get 'get_pdf', to: 'catalogs#get_pdf', as: 'get_pdf'
        get 'get_pdf/:locale_pdf', to: 'catalogs#get_pdf', as: 'get_pdf_locale'
      end
    end

    get '/', to: 'index#index', as: 'index'
    resources :products do
      member do
        get 'like', to: 'products#like', as: 'like'
      end
    end

    resources :posts do
      member do
        get 'like', to: 'posts#like', as: 'like'
      end
    end

    get '/register', to: 'registrations#index', as: 'register'

    post '/information/enquire', to: 'informations#enquire', as: 'enquire'

    resources :products do

    end
    resources :categories do
      collection do
        get '/:id/products', to: 'categories#products', as: 'category_products'
        get '/:id/catalogs', to: 'categories#catalogs', as: 'category_catalogs'
        get '/:id/companies', to: 'categories#companies', as: 'category_companies'
        get '/:parent_id/:id', to: 'categories#subcategory', as: 'subcategory'
        get '/list', to: 'categories#list', as: 'list'
      end

    end

    get '/change_locale/:locale_new', to: 'utilities#switch_locale', as: 'change_locale'
  end





  namespace :backend do
    resources :visitors, only: [:index]
    resources :dashboard, only: [:index] do
      collection do
        get '/activity', to: 'dashboard#activity', as: 'activity'
      end
    end
    resources :searches do #, only: [:index,]
    end

    resources :catalogs do
      collection do
        post '/search', to: 'catalogs#search', as: 'search'
      end
      member do
          delete '/remove_pdf/:locale_pdf', to: 'catalogs#remove_pdf', as: 'remove_pdf'
      end
    end

    resources :users do
      collection do
        post '/search', to: 'users#search', as: 'search'
        get 'all_payments', to: 'users#all_payments', as: 'all_payments'
        get 'index_companies', to: 'users#index_companies', as: 'index_companies'
        post 'index_companies', to: 'users#index_companies', as: 'index_companies_post'
        post '/', to: 'users#index', as: 'index_post'
      end
      member do
        get 'card_info', to: 'users#card_info', as: 'card_info'
        get 'switch_plan', to: 'users#switch_plan', as: 'switch_plan'
        get 'payments', to: 'users#payments', as: 'payments'
      end
    end

    #resources :favorites, only: [:index] do
    get '/favorites/:kind', to: 'favorites#index', as: 'favorites'
    post '/favorites/:kind', to: 'favorites#index', as: 'favorites_p'
    post '/favorites/search', to: 'favorites#search', as: 'search_favorites'

    resources :posts do
      collection do
        post '/search', to: 'posts#search', as: 'search'
      end
      member do
          delete '/remove_picture', to: 'posts#remove_picture', as: 'remove_picture'
      end


    end

    resources :carousels do
      collection do
        post '/search', to: 'carousels#search', as: 'search'
      end
    end
    resources :products do
      collection do
        post '/search', to: 'products#search', as: 'search'
      end
    end
    resources :informations do

    end


  end
end
