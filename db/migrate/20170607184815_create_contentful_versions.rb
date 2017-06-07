class CreateContentfulVersions < ActiveRecord::Migration
  def change
    create_table :contentful_versions do |t|
      t.string :change_message, :limit => 255
      t.column :contentful_payload, :json

      t.timestamps
    end
  end
end
