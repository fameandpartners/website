class UpdateGiftVariantSku < ActiveRecord::Migration
  def change
    v = Spree::Variant.where(sku: "gift-Color:Socialize").first
    v.sku = 'GIFTC278'
    v.save!

    v = Spree::Variant.where(sku: "gift-Color:Morocco").first
    v.sku = 'GIFTC279'
    v.save!

    v = Spree::Variant.where(sku: "gift-Color:FireRed").first
    v.sku = 'GIFTC280'
    v.save!

    v = Spree::Variant.where(sku: "gift-Color:Casablanca").first
    v.sku = 'GIFTC281'
    v.save!
  end
end
