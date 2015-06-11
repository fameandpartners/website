namespace :feed do
  namespace :export do
    task all: :environment do
      if Rails.env.production?
        Feeds::Base.export!('au')
        Feeds::Base.export!('us')
      else
        puts 'feed:export:all disabled for non-production env'
      end
    end
  end
end
