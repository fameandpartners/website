namespace :data do
  desc 'Add slow making options to existing products'
  task :add_slow_making => :environment do
    counter = 1
    Spree::Product.find_each do |prd|
      prdmo = ProductMakingOption.new( active: true,
                                          option_type: 'slow_making',
                                          price: -0.1,
                                          currency: 'USD')
      prd.making_options << prdmo
      prd.save
      puts counter
      counter += 1
    end
  end
end
