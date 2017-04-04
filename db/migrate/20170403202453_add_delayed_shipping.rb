class AddDelayedShipping < ActiveRecord::Migration
  def up
    Spree::Product.find_each do |prd|
      prdmo = ProductMakingOption.new( active: true,
                                          option_type: 'slow_making',
                                          price: -0.1,
                                          currency: 'USD')
      prd.making_options << prdmo
      prd.save
    end

  end

  def down
    ProductMakingOption.where(option_type: 'slow_making').find_each do |prdmo|
      prdmo.delete
    end

  end
end
