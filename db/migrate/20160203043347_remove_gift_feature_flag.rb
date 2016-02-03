class RemoveGiftFeatureFlag < ActiveRecord::Migration
  def up
    SimpleKeyValue::FeatureMigration.remove_feature(:gift)
  end

  def down
    # No Op
  end
end
