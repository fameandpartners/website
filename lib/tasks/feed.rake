namespace :feed do
  namespace :export do
    task :all => :environment do
      Feeds::Base.export!('au')
      Feeds::Base.export!('us')
    end
  end
end
