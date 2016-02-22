class PublishEventBridesmaidTaxon < ActiveRecord::Migration
  def up
    if (event_bridesmaid = Spree::Taxon.where(permalink: 'event/bridesmaid').first)
      event_bridesmaid.publish!
    end
  end

  def down
    # NOOP
  end
end
