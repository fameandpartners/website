class FixColorDataForAllProducts < ActiveRecord::Migration
  def up
    Spree::Product.all.each do |p|
      colors = p.colors
      p.product_color_values.each do |v|
        if !colors.include?(v.option_value.name)
          v.active = false
          v.custom = true
          v.save!
        end
      end
    end
  end

  def down
    #NOOP
  end
end
