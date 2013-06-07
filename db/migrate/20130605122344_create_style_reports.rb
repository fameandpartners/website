class CreateStyleReports < ActiveRecord::Migration
  def change
    create_table :style_reports do |t|
      t.references :spree_user
      t.float :glam
      t.float :girly
      t.float :classic
      t.float :edgy
      t.float :bohemian
      t.float :sexiness
      t.float :fashionability

      t.timestamps
    end

    add_index :style_reports, :spree_user_id
  end
end
