class CreateRevolutionTranslations < ActiveRecord::Migration
  def change
    create_table :revolution_translations do |t|
      t.integer :page_id, :nil => false
      t.text    :locale, :nil => false
      t.text    :title, :nil => false
      t.text    :meta_description, :nil => false
      t.text    :heading, :nil => false
      t.text    :sub_heading, :nil => true
      t.text    :description, :nil => true
      t.timestamps
    end

    add_index :revolution_translations, :page_id
    add_index :revolution_translations, :locale

  end
end
