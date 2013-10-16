class DropPersonalizationSettings < ActiveRecord::Migration
  def up
    drop_table :personalization_settings
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
