class AddTaxonHex < ActiveRecord::Migration
  def up
    add_column :spree_taxons, :hex, :string
  end
end
