task :picture_categories => :environment do

  Category.roots.each do |c|
    if c.children.present?
      I18n.locale = :en
      url = 'https://catalogindustry.com/' + c.slug + ".jpg"
      p url
      c.remote_picture_url = url
      c.save

    end
  end

end
