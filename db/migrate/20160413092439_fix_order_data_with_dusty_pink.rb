class FixOrderDataWithDustyPink < ActiveRecord::Migration
  def up
    line_item_personalization = Spree::Order.where(number: 'R742871563').first.line_items.last.personalization
    if line_item_personalization.color_id == 236
      line_item_personalization.color_id = 173
      line_item_personalization.save!
    end
  end
end
