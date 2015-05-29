class CreateRevolutionTemplates < ActiveRecord::Migration
  def change
    create_table :revolution_templates do |t|
      t.text    :name
      t.boolean :custom, :nil => false, :default => false
      t.text    :data, :nil => true
      t.timestamps
    end

  end
end
