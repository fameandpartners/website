require 'pathname'

namespace :orderbot do

  namespace: :products do
    desc 'Sync all of the products to orderbot'    
    task :sync => :environment do
    end
  end

  namespace: :orders do
    desc 'Sync all of the orders to orderbot'    
    task :sync => :environment do
    end
  end
  

end
