class UpdateTrackingNumbers < ActiveRecord::Migration

  def up
    orders = {
      'R218370811' => '5988372305',
      'E460662077' => '5988226580',
      'E625434523' => '2326323403',
      'E710215800' => '5414416582',
      'R573876378' => '9801757210',
      'R860044172' => '9801757210',
      'R360818471' => '4557995083',
      'R613863247' => '4557995083',
      'R383756418' => '3123746592',
      'R214828582' => '3123818316',
      'R403158341' => '5270504912',
      'R170215248' => '5988238620',
      'R018584027' => '5988244006',
      'R267152573' => '6427979434',
      'R748643322' => '6427985130',
      'R616423780' => '6427990472',
      'R173376427' => '5952510104',
      'R765124843' => '2136331385',
      'R338774721' => '2136332214',
      'R807788540' => '2136333076',
      'R380334457' => '2136335121',
      'R046338652' => '2136336823',
      'R106671350' => '2136339332',
      'E818045873' => '5763582720',
      'R654740485' => '6347574940',
      'R613222506' => '6347576815',
      'R521427472' => '6347614770',
      'R176465381' => '2711327975',
      'R148168537' => '2136183954',
      'R605020066' => '2136319754',
      'R448152887' => '2136325446',
      'R741881251' => '2136327244',
      'R280645232' => '2136343926',
      'R627217112' => '2136351501',
      'R622163552' => '2136353225',
      'R854623034' => '2136364565',
      'R347618315' => '2136366466',
      'R850880680' => '2136374030',
      'R410405720' => '2136378565',
      'R813160118' => '2136399683',
      'R306564655' => '2136401853',
      'R132052237' => '2136421755',
      'R854302042' => '3876123145',
      'R344201028' => '5823682841',
      'R355527423' => '5823310511',
      'R008638517' => '3875731355',
      'R280884422' => '5823660080',
      'R073245032' => '5823318642',
      'R461551886' => '1746539701',
      'R605020066' => '6347571134',
      'R711611857' => '6347625292',
      'R873056560' => '6347627230',
      'R704040801' => '6347627904',
      'R475648761' => '6347600442',
      'R684313213' => '6347600442',
      'R656637800' => '5823704655',
      'R810383541' => '5823715811',
      'R738022065' => '5823722833',
      'R873587464' => '5823728326'
    }

    orders.each do |order_number, tracking_number|
      if (order = Spree::Order.where(number: order_number).first)
        if (shipment = order.shipments.first)
          unit            = shipment.inventory_units.build
          unit.variant_id = order.line_items.first.variant.id
          unit.order_id   = order.id
          unit.save

          shipment.tracking = tracking_number
          shipment.save
        end
      end
    end
  end

  def down
  end
end
