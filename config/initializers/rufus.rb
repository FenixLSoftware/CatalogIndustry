require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '0 12 * * *' do
  # do something every day, at midday

  #todos los que tengan plan premium encendido y fecha de next_payment anterior a la hora actual
  User.process_payments
  #recalculamos las busquedas
  Search.refresh_searches



end

scheduler.cron '0 10 * * *' do
  system 'bundle exec rake sitemap:generate RAILS_ENV=' + Rails.env.to_s
end
