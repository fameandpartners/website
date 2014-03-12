class CreateUserStyleProfileTaxons < ActiveRecord::Migration
  def change
    create_table :user_style_profile_taxons do |t|
      t.integer :user_style_profile_id
      t.integer :taxon_id
      t.integer :capacity
    end
  end
end
