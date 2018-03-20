namespace :feed do
  namespace :export do
    desc 'Export Marketing Feeds'
    task all: :environment do
      # Feeds::Base.export!('au')
      Feeds::Base.export!('us')
    end
  end
end
