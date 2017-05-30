namespace :data do
  desc 'Add slow making options to existing products'
  task :add_slow_making => :environment do
    counter = 0
    Spree::Product.find_each do |prd|
      if prd.making_options.none? {|mo| mo.option_type == 'slow_making'}
        prdmo = ProductMakingOption.create( active: true,
                                            option_type: 'slow_making',
                                            price: -0.1,
                                            currency: 'USD')
        prd.making_options << prdmo
        prd.save!
        counter += 1
        puts counter
      end
        puts 'punt'
    end
    puts "#{counter} slooow making options added"
  end
end


