class Import < ApplicationRecord

  require "base64"

  def self.invent_posts
    all_users = User.role_company
    ccc = Catalog.all
    50.times do
      p = Post.new
      p.title = Faker::Lorem.sentence
      p.description = Faker::Lorem.paragraph(2, false, 4)
      p.validated = true
      p.user = all_users.shuffle.first


      p.remote_picture_url =  'https://picsum.photos/' + (1400 + ((-15..15).to_a.sample)).to_s  + '/' + (650 + ((-15..15).to_a.sample)).to_s
      #p.product_pictures << ProductPicture.new(remote_picture_url: 'http://lorempixel.com/400/400/food/')
      #p.product_pictures << ProductPicture.new(remote_picture_url: 'http://lorempixel.com/400/400/food/')
      #p.product_pictures << ProductPicture.new(remote_picture_url: 'http://lorempixel.com/400/400/food/')

      if p.valid?
        p.save
      else
        p.errors.to_a
      end
    end

  end

  def self.invent_products
    all_users = User.role_company
    ccc = Catalog.all
    50.times do
      p = Product.new
      p.name = Faker::Lorem.sentence
      p.description = Faker::Lorem.paragraph(2, false, 4)
      p.keywords = Faker::Lorem.sentence.gsub(" ", ", ")
      p.validated = true
      categories = []
      c = Category.roots.shuffle.first.children.shuffle.first
      if c.present?
        p.categories << c
      end
      c = Category.roots.shuffle.first.children.shuffle.first
      if c.present?
        p.categories << c
      end
      c = Category.roots.shuffle.first.children.shuffle.first
      if c.present?
        p.categories << c
      end
      p.user = all_users.shuffle.first


      p.product_pictures << ProductPicture.new(picture:  Rails.root.join(ccc.shuffle[0].first_page_picture.path).open)
      #p.product_pictures << ProductPicture.new(remote_picture_url: 'http://lorempixel.com/400/400/food/')
      #p.product_pictures << ProductPicture.new(remote_picture_url: 'http://lorempixel.com/400/400/food/')
      #p.product_pictures << ProductPicture.new(remote_picture_url: 'http://lorempixel.com/400/400/food/')

      if p.valid?
        p.save
      else
        p.errors.to_a
      end
    end

  end
  def self.import_catalogs
    Catalog.all.destroy_all

    server  = Mysql2::Client.new(:host => Rails.application.secrets.dbserver_import, :username => Rails.application.secrets.username_import, :password => Rails.application.secrets.password_import, :database => Rails.application.secrets.databasename_import)

    catalogs = server.query("SELECT * FROM _catalog order by catalogId asc")
    #_document_type_locale tiene el tipo de catalogo
    catalogs.each do |catalog|

      #buscamos en user el dueño del catalogo y luegopor el email se lo asignamos al user que sea
      c = Catalog.new
      c.validated = true
      comp = server.query("SELECT * FROM user WHERE companyId = " + catalog["companyId"].to_s)
      user = nil
      comp.each do |company|
        user = User.find_by_email(company['userName'])
      end

      c.user = user
      if c.user.present?


        #los locales
        cl = server.query("SELECT * FROM _catalog_locale where catalogId = " + catalog["catalogId"].to_s)

        cl.each_with_index do |c_locale, idx|
          file_path = ("import_files/CICatalogLocale/00/00/" + Import.file_name_and_path(c_locale["localeId"]))
          unless File.exists? file_path
            #entiendo que ya lo renombré
            file_path = file_path + '.pdf'
          end
          if File.extname(file_path) == ''
            File.rename(file_path, (file_path + '.pdf'))
            file_path = file_path + '.pdf'
          end
          if c_locale["locale"] == 'de_DE'

            if File.exist?(file_path)
              I18n.locale = :de
              c.name = c_locale["title"]
              c.description = c_locale["description"]
              c.keywords = c_locale["keywords"][0..254]
              c.pdf = Rails.root.join(file_path).open
              c.save
              Catalog.delay.extract_pages(c, c.pdf.path, I18n.locale)
              p c_locale["title"]
            end
          end

          if c_locale["locale"] == 'en_US'
            #file_path = ("import_files/CICatalogLocale/00/00/" + Import.file_name_and_path(c_locale["localeId"]))
            if File.exist?(file_path)
              I18n.locale = :en
              c.name = c_locale["title"]
              c.description = c_locale["description"]
              c.keywords = c_locale["keywords"][0..254]
              c.pdf = Rails.root.join(file_path).open
              c.save
              Catalog.delay.extract_pages(c, c.pdf.path, I18n.locale)
              p c_locale["title"]
            end
          end

          if c_locale["locale"] == 'fr_FR'
            #file_path = ("import_files/CICatalogLocale/00/00/" + Import.file_name_and_path(c_locale["localeId"]))
            if File.exist?(file_path)
              I18n.locale = :fr
              c.name = c_locale["title"]
              c.description = c_locale["description"]
              c.keywords = c_locale["keywords"][0..254]
              c.pdf = Rails.root.join(file_path).open
              c.save
              Catalog.delay.extract_pages(c, c.pdf.path, I18n.locale)
              p c_locale["title"]
            end
          end

          if c_locale["locale"] == 'es_ES'
            #file_path = ("import_files/CICatalogLocale/00/00/" + Import.file_name_and_path(c_locale["localeId"]))
            if File.exist?(file_path)
              I18n.locale = :es
              c.name = c_locale["title"]
              c.description = c_locale["description"]
              c.keywords = c_locale["keywords"][0..254]
              c.pdf = Rails.root.join(file_path).open
              c.save
              Catalog.delay.extract_pages(c, c.pdf.path, I18n.locale)
              p c_locale["title"]
            end
          end

          if c_locale["locale"] == 'it_IT'
            #file_path = ("import_files/CICatalogLocale/00/00/" + Import.file_name_and_path(c_locale["localeId"]))
            if File.exist?(file_path)
              I18n.locale = :it
              c.name = c_locale["title"]
              c.description = c_locale["description"]
              c.keywords = c_locale["keywords"][0..254]
              c.pdf = Rails.root.join(file_path).open
              c.save
              Catalog.delay.extract_pages(c, c.pdf.path, I18n.locale)
              p c_locale["title"]
            end
          end
        end



        #la categoria de la que cuelga
        ccg = server.query("SELECT * FROM _catalog_category_group WHERE catalogId = " + catalog["catalogId"].to_s)
        ccg.each do |cc|
          cat_cat = server.query("SELECT * FROM _catalog_category where categoryId = " + cc["categoryId"].to_s)
          ct = nil
          cat_cat.each do |cct|
            ct = cct["categoryBaseId"]
          end
          #buscamos la catgoria que tiene ese temp_path
          final_cat = Category.find_by_temp_path(ct)
          c.categories << final_cat

        end

        if c.valid?
          c.save
        else
          p c.errors.to_a



        end

      else


      end

      #el archivo esta en cicataloglocale con id localeid de _catalog_locale

    end
    true

  end

  def self.import_categories

    Category.all.destroy_all

    server  = Mysql2::Client.new(:host => Rails.application.secrets.dbserver_import, :username => Rails.application.secrets.username_import, :password => Rails.application.secrets.password_import, :database => Rails.application.secrets.databasename_import)

        # migrar las catgorias
    categories = server.query("SELECT * FROM category order by path asc")
    categories.each do |cat|
      #creamos la categoria
      c = Category.new
      c.temp_path = cat["categoryBaseId"].to_i
      #buscamos los locales de esa categoria
      cl = server.query("SELECT * FROM category_locale where categoryBaseId = " + cat["categoryBaseId"].to_s)
      cl.each do |c_locale|
        if c_locale["locale"] == 'de_DE'
          I18n.locale = :de
          c.name = c_locale["name"]
        end

        if c_locale["locale"] == 'en_US'
          I18n.locale = :en
          c.name = c_locale["name"]
        end

        if c_locale["locale"] == 'fr_FR'
          I18n.locale = :fr
          c.name = c_locale["name"]
        end

        if c_locale["locale"] == 'es_ES'
          I18n.locale = :es
          c.name = c_locale["name"]
        end

        if c_locale["locale"] == 'it_IT'
          I18n.locale = :it
          c.name = c_locale["name"]
        end
      end
      I18n.locale = :en

      #ahora vemos si es o no railz
      if cat["path"] ==''
        # es raiz, la hacemos parent
        c.parent = nil
      else
        #es hija de alguien

        #quitamos la barra
        parent = cat["path"].gsub '/', ''
        # busco en la otra tabla de nuevo
        help = server.query("SELECT * FROM _catalog_category where categoryId = " + parent.to_s)
        help.each do |h|
          par = h["categoryBaseId"]
          c.parent = Category.find_by(temp_path: par)
        end
      end
      unless c.name.present?

      else
        if c.valid?
          c.save
        else
          p c.errors

        end
      end
    end
    true

  end

  def self.complete_users
    server  = Mysql2::Client.new(:host => Rails.application.secrets.dbserver_import, :username => Rails.application.secrets.username_import, :password => Rails.application.secrets.password_import, :database => Rails.application.secrets.databasename_import)

    user_errors = []

    is_company = false

    # todos los clientes
    users = server.query("SELECT * FROM user order by userId")
    users.each do |user|
      #buscamos a cada uno y le ponems bin la password
      u = User.find_by_email(user["userName"])
      #p user["userName"]
      if u.present?
        p 'Fix: ' + u.name
        u.password = Base64.decode64(user["psw"])

        website = server.query("SELECT * FROM _user where userId = " + user["userId"].to_s)
        if website.count > 0 then
          website_item = website.first
          u.website = (website_item["website"].to_s).rstrip
          u.position = (website_item["position"].to_s).rstrip
          u.user_company_name = (website_item["company"].to_s).rstrip

          if u.website.present?
            u.website.slice!('https://')
            u.website.slice!('http://')
            u.website = 'http://' + u.website.to_s
            p u.website.to_s + ' * ' + u.position.to_s + " " + u.user_company_name.to_s
          end
        end
        if u.valid?
          u.save
        else
          cebolla2
        end
      end

    end

  end

  def self.import_users
    User.all.destroy_all

    user = CreateAdminService.new.call

    server  = Mysql2::Client.new(:host => Rails.application.secrets.dbserver_import, :username => Rails.application.secrets.username_import, :password => Rails.application.secrets.password_import, :database => Rails.application.secrets.databasename_import)



    user_errors = []

    is_company = false

    # todos los clientes
    users = server.query("SELECT * FROM user order by userId")
    users.each do |user|
      is_company = false
      #p user
      u = User.new
      u.validated = true
      u.email = user["userName"]
      u.password = Base64.decode64(user["psw"])
      if user["humanId"].present?
        human = server.query("SELECT * FROM human where humanId = " + user["humanId"].to_s)
        if human.count > 0 then
          human_item = human.first
          u.name = (human_item["name"].to_s.rstrip + ' ' + human_item["middleName"].to_s.rstrip).rstrip
        end

      end

      #ver is es empresa
      if user["companyId"].present?
        is_company = true

        #buscamos el logo
        file_logo = ("import_files/CICompany/00/00/" + Import.file_name_and_path_users(user["userId"]))

        if File.exists?(file_logo)
          u.company_picture =  Rails.root.join(file_logo).open
        end
        #fin logo

        company = server.query("SELECT * FROM company where companyId = " + user["companyId"].to_s)
        if company.count > 0 then
          company_item = company.first
          u.company_name = (company_item["name"].to_s).rstrip
          # buscamos direcciones y telefonoes de esa empresa
          phone = server.query("SELECT * FROM company_phone where companyId = " + user["companyId"].to_s)
          if phone.count > 0 then
            phone_item = phone.first
            u.phone = (phone_item["number"].to_s).rstrip
          end
          address = server.query("SELECT * FROM company_address where companyId = " + user["companyId"].to_s)
          if address.count > 0 then
            address_item = address.first
            u.address = (address_item["address"].to_s).rstrip
            u.city = (address_item["city"].to_s).rstrip
            u.postal = (address_item["postalCode"].to_s).rstrip
            u.country = (address_item["country"].to_s).rstrip.sub!( 'LOC_COUNTRY_', '')
            u.state = (address_item["state"].to_s).rstrip

          end
          #descripcion compañia
          locales = server.query("SELECT * FROM _company_locale where companyId = " + user["companyId"].to_s)
          locales.each do |locale|
            if locale["locale"] == 'de_DE'
              I18n.locale = :de
              u.description = locale["description"]
            end

            if locale["locale"] == 'en_US'
              I18n.locale = :en
              u.description = locale["description"]
            end

            if locale["locale"] == 'fr_FR'
              I18n.locale = :fr
              u.description = locale["description"]
            end

            if locale["locale"] == 'es_ES'
              I18n.locale = :es
              u.description = locale["description"]
            end

            if locale["locale"] == 'it_IT'
              I18n.locale = :it
              u.description = locale["description"]
            end
          end
          I18n.locale = :en



        end
      end

      if u.valid?
        u.save
        if is_company
          u.role_company!
        else
          u.role_professional!
        end
        p "OK"
      else
        user_errors << [u, u.errors.to_a]
        p u.errors.to_a
      end

      #ponerle sus categorias, las que le gustan

      #los logos estan en CICompany /xx/xx/ sacado de user_id de users
    end
    user_errors

  end

  def self.file_name_and_path(localeId)

    last_path = localeId.to_s.rjust(5, '0')
    first = last_path[0, 3]
    last = last_path[3, 2]

    first + "/" + last + "_pdf"

  end

  def self.file_name_and_path_users(localeId)

    last_path = localeId.to_s.rjust(5, '0')
    first = last_path[0, 3]
    last = last_path[3, 2]

    first + "/" + last + "_logo"

  end
  #estadisticas importacion: con macbook pro de carlos garcia:
  #en 30 minutos procesa 20 catalogos con 2 micros.
  #en 60 minutos procesa 40 con 2 micros
  #en 60 minutos procesa 20 con 1 micro
  #por tanto procesa 20 catalogos por hora por cada micro.
  # para procesar 4200 catalogos aprox, 210 horas con 1 micro
  # con una maquina de 96 micros, necesitará 2.1 horas para hacer los 4200

  #espacio
  #son aproximadamente 20 mb en paginas por cada catálogo
  # salen 80 gb en páginas al acabar la migracion

  #catalogos
  #son 8 MB de media por cata catalogo en varios idiomas
  #para 4200 catalogos, serian 32 GB de PDF

  #archivos originales que luego se eliminan: 40 GB de datos de migración

  #la maquina para tener un minimo de capacidad para el futuro,necesita un HDD de unos 250 GB

  #en el momento de la migracion deberia ser una AWS m5.24xlarge
end
