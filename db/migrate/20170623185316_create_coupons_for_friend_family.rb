class CreateCouponsForFriendFamily < ActiveRecord::Migration
  def up
    peeps = ["BondA", "GarciaS", "AlwiT", "BeckmanL", "AmbrizN", "BarnabyA", "DeFinoJ", "MeyerM", "RitaccoA", "VarinskyA", "CannelosL", "TannreutherM", "SchuldA", "RiveraR", "TruongT", "MorrowP", "ChungD", "SamraN", "SellersD", "StigileL", "CorbyN", "KeigL", "FarrJ", "HoL", "RomeroG", "FarisC", "ChihF", "ZhangJ", "SuR", "BaoS", "ChenL ", "YuanL", "JiangC", "ChenI", "YanL", "ChengK ", "HuF ", "MaM", "ZhengP ", "LiuO", "WangJ", "YangD", "YuK", "XuA", "YanL", "FeiZ", "PriceD", "SavageL", "CorbyA", "GnanakoneM", "MingM"]

    promo_codes = peeps.inject([]) do |acc, name|
      ncodes = (1..5).map { |i| "#{name.downcase}ff#{i}" }
      acc.concat(ncodes)
    end

    promo_codes.each do |code|
      promotion                             = Spree::Promotion.new
      promotion.name                        = "Friends and Family"
      promotion.description                 = "Friends and Family #{code}"
      promotion.expires_at                  = Date.new(2017, 12, 31)
      promotion.starts_at                   = 1.days.ago
      promotion.event_name                  = 'spree.checkout.coupon_code_added'
      promotion.usage_limit                 = 1
      promotion.match_policy                = 'all'
      promotion.code                        = code
      promotion.advertise                   = false
      promotion.eligible_to_custom_order    = true
      promotion.eligible_to_sale_order      = false
      promotion.require_shipping_charge     = false
      promotion.save

      calculator                        = Spree::Calculator::FlatPercentItemTotal.create
      calculator.preferred_flat_percent = 25.0
      calculator.save

      promotion_action          = Spree::Promotion::Actions::CreateAdjustment.create
      promotion_action.activator_id = promotion.id
      promotion_action.calculator   = calculator
      promotion_action.save

    end
  end

  def down
    Spree::Promotion.where(name: 'Friends and Family').find_each do |promotions|
      promotion.actions.map(&:destroy)
      promotion.destroy
    end
  end
end
