class DeleteCustomizationValuesWithoutProducts < ActiveRecord::Migration
  def self.up
    CustomisationValue.where('product_id IS NULL').destroy_all
  end

  def self.down
    raise IrreversibleMigration
  end
end
