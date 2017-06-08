require 'pathname'

namespace :orderbot do

  namespace :product_structure do
    desc 'Sync all of the product structure / groups to orderbot'
    task :sync => :environment do
      orderbot_product = Orderbot::ProductGroup.sinc
    end
  end
  
  namespace :products do
    desc 'Sync all of the products to orderbot'    
    task :sync => :environment do
      orderbot_product = Orderbot::Product.new( 1380 )
      orderbot_product.create
    end
  end

  namespace :orders do
    desc 'Sync all of the orders to orderbot'    
    task :sync => :environment do
    end
  end
  

end
