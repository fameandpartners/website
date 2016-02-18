class MergeBridemaidsTaxon < ActiveRecord::Migration
  def up
    bridesmaid_product_ids = (range_bridesmaid_taxon.product_ids + event_bridesmaid_taxon.product_ids).uniq

    event_bridesmaid_taxon.product_ids = bridesmaid_product_ids
    event_bridesmaid_taxon.save!

    event_bridesmaid_taxon.publish!
    range_bridesmaid_taxon.destroy
  end

  def down
    # NOOP
  end

  private def range_bridesmaid_taxon
    Spree::Taxon.find(217)
  end

  private def event_bridesmaid_taxon
    Spree::Taxon.find(221)
  end
end
