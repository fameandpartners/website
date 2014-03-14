class DestroyOldCustomizationValues < ActiveRecord::Migration
  def self.up
    CustomisationValue.where('customisation_type_id IS NOT NULL').destroy_all
  end

  def self.down
    raise IrreversibleMigration
  end
end
