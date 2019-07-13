task :re_slug => :environment do

  Catalog.all.each do |c|
    I18n.available_locales.each do |l|
      I18n.locale = l
      if c.slug.to_s.size == 36
        c.slug = c.name.to_s.parameterize + '-' + rand(200000).to_s
        c.save
        p l.to_s
        p c.name
        p c.slug
      end
    end
  end
end
