class AddIndexToSimpleKeyValueKey < ActiveRecord::Migration
  def change
    add_index :simple_key_values, :key, unique: true
  end
end
