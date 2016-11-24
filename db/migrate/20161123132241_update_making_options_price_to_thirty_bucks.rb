class UpdateMakingOptionsPriceToThirtyBucks < ActiveRecord::Migration
  def up
    ProductMakingOption.where(option_type: 'fast_making').find_each do |making_option|
      making_option.price = 30
      making_option.save
    end
  end

  def down
    # NOOP
  end
end
