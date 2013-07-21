class CreateCelebrities < ActiveRecord::Migration
  def change
    create_table :celebrities, force: true do |t|
      t.string :name

      t.timestamps
    end
  end
end
