class UseWhiteAsRecommendedColorForRegina < ActiveRecord::Migration
  def up
    p = Spree::Product.where(name: "Regina").first
    if p.present?
      ivory = p.product_color_values.where(custom: false).first
      ivory.destroy if ivory.option_value.name == "ivory"
      p.product_color_values.each do |v|
        if v.option_value.name == "white"
          v.custom = false
          v.save!
        end
      end
    end
  end

  def down
    #NOOP
  end
end
