class UpdateTrackingNumbers < ActiveRecord::Migration

  def up
    orders = {
      'R218370811' =>	'5988372305',
      'E460662077' =>	'5988226580',
      'E625434523' =>	'2326323403',
      'E710215800' =>	'5414416582',
      'R573876378' =>	'9801757210',
      'R860044172' =>	'9801757210',
      'R360818471' =>	'4557995083',
      'R613863247' =>	'4557995083',
      'R383756418' =>	'3123746592',
      'R214828582' =>	'3123818316',
      'R403158341' =>	'5270504912',
      'R170215248' =>	'5988238620',
      'R018584027' =>	'5988244006',
      'R267152573' =>	'6427979434',
      'R748643322' =>	'6427985130',
      'R616423780' =>	'6427990472',
      'R173376427' =>	'5952510104'
    }

    orders.each do |k,v|
      order = Spree::Order.where(number: k).first

      unit = order.shipments.first.inventory_units.build
      unit.variant_id = order.line_items.first.variant.id
      unit.order_id = order.id
      unit.save

      shipment = order.shipments.first
      shipment.tracking = v
      shipment.save
    end
  end

  def down
  end
end
