task :slug_categories => :environment do

  Category.all.each do |c|
    I18n.locale = :en
    n = c.name
    p "**************"
    p n
    p "**************"
    c.translations.each do |t|
      I18n.locale = t.locale.to_sym
      t.slug = c.name.parameterize
      t.save
      p I18n.locale.to_s + " " + c.name +  " ===> " + c.name.parameterize
    end
  end

end
