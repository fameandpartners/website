class AddSkuToGift < ActiveRecord::Migration
  def change
    x= Spree::Product.where(name: 'Gift').first
    x.sku = 'Gift'
    x.save!
  end
end
