class CreateFactories < ActiveRecord::Migration
  def change
    create_table :factories do |t|
      t.text :name
      t.timestamps
    end
  end
end
