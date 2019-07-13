if Rails.env == 'production'
  host 'catalogindustry.com' # https://freeditorial.com "#{request.host_with_port}"
else
  host 'localhost:3000'
end

languages_avaliable = [:es, :en, :fr, :de, :it] #, :zh]
if Rails.env == 'production'
  protocol = 'https://'
else
  protocol = 'http://'
end

sitemap :site do
  # home
  languages_avaliable.each do |lang|
    url "#{protocol}#{host}/#{lang.to_s}", last_mod: Time.now, change_freq: "daily", priority: 1.0
  end

  # publish
  languages_avaliable.each do |lang|
    url "#{protocol}#{host}/#{lang.to_s}/static/publish/", last_mod: Time.now, change_freq: "daily", priority: 1.0
  end

  # contact
  languages_avaliable.each do |lang|
    url "#{protocol}#{host}/#{lang.to_s}/static/contact/", last_mod: Time.now, change_freq: "daily", priority: 1.0
  end

  # blog
  languages_avaliable.each do |lang|
    url "#{protocol}#{host}/#{lang.to_s}/blog/", last_mod: Time.now, change_freq: "daily", priority: 1.0
  end

  # privacy
  languages_avaliable.each do |lang|
    url "#{protocol}#{host}/#{lang.to_s}/static/privacy_policy/", last_mod: Time.now, change_freq: "daily", priority: 1.0
  end

  # legal
  languages_avaliable.each do |lang|
    url "#{protocol}#{host}/#{lang.to_s}/static/legal_notice/", last_mod: Time.now, change_freq: "daily", priority: 1.0
  end

  # list catalogs
  languages_avaliable.each do |lang|
    url "#{protocol}#{host}/#{lang.to_s}/catalogs/", last_mod: Time.now, change_freq: "daily", priority: 1.0
  end
  # list products
  languages_avaliable.each do |lang|
    url "#{protocol}#{host}/#{lang.to_s}/products/", last_mod: Time.now, change_freq: "daily", priority: 1.0
  end
  # list companies
  languages_avaliable.each do |lang|
    url "#{protocol}#{host}/#{lang.to_s}/users/", last_mod: Time.now, change_freq: "daily", priority: 1.0
  end
  # list categories
  languages_avaliable.each do |lang|
    url "#{protocol}#{host}/#{lang.to_s}/categories/", last_mod: Time.now, change_freq: "daily", priority: 1.0
  end
end

sitemap :categories do
  # all catalogs + view online
  languages_avaliable.each do |lang|
    Category.with_translations(lang).all.roots.each do |root_cat|
      Globalize.with_locale(lang) do
        if root_cat.children.present?
          url "#{protocol}#{host}/#{lang.to_s}/categories/#{root_cat.slug}/", last_mod: Time.now, change_freq: "daily", priority: 1.0
          root_cat.children.each do |children|
            url "#{protocol}#{host}/#{lang.to_s}/categories/#{root_cat.slug}/#{children.slug}/", last_mod: Time.now, change_freq: "daily", priority: 1.0
          end
        end
      end
    end
  end
end

sitemap :catalogs do
  # all catalogs + view online
  languages_avaliable.each do |lang|
    I18n.locale = lang
    Catalog.visible_front.each do |catalog|
      url "#{protocol}#{host}/#{lang.to_s}/catalogs/#{catalog.slug}/", last_mod: Time.now, change_freq: "daily", priority: 1.0
      url "#{protocol}#{host}/#{lang.to_s}/catalogs/#{catalog.slug}/view_online/", last_mod: Time.now, change_freq: "daily", priority: 1.0
    end
  end
end

sitemap :products do
  # all products
  languages_avaliable.each do |lang|
    I18n.locale = lang
    Product.visible_front.each do |product|
      url "#{protocol}#{host}/#{lang.to_s}/products/#{product.slug}/", last_mod: Time.now, change_freq: "daily", priority: 1.0
      url "#{protocol}#{host}/#{lang.to_s}/products/#{product.slug}/view_online/", last_mod: Time.now, change_freq: "daily", priority: 1.0
    end
  end
end



sitemap :users do
  # all catalogs
  languages_avaliable.each do |lang|
    I18n.locale = lang
    User.visible_front.role_company.each do |company|
      url "#{protocol}#{host}/#{lang.to_s}/users/#{company.slug}", last_mod: Time.now, change_freq: "daily", priority: 1.0
      url "#{protocol}#{host}/#{lang.to_s}/users/#{company.slug}/menu_catalog", last_mod: Time.now, change_freq: "daily", priority: 1.0
      url "#{protocol}#{host}/#{lang.to_s}/users/#{company.slug}/menu_product", last_mod: Time.now, change_freq: "daily", priority: 1.0
      url "#{protocol}#{host}/#{lang.to_s}/users/#{company.slug}/menu_new", last_mod: Time.now, change_freq: "daily", priority: 1.0
    end
  end
end

ping_with "https://#{host}/sitemaps/sitemap.xml"
