class AddSeoFieldsToPages < ActiveRecord::Migration
  def change
    add_column :revolution_pages, :noindex, :boolean, :default => false
    add_column :revolution_pages, :nofollow, :boolean, :default => false
  end
end
