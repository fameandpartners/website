require 'pathname'

namespace :orderbot do

  namespace: :products do
    desc 'Sync all of the products to orderbot'    
    task :sync => :environment do
      orderbot_product = Orderbot::Product.new( 1380 )
      orderbot_product.sync
    end
  end

  namespace: :orders do
    desc 'Sync all of the orders to orderbot'    
    task :sync => :environment do
    end
  end
  

end
