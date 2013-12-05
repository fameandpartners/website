class AddIsPublishedToCelebrities < ActiveRecord::Migration
  def change
    add_column :celebrities, :is_published, :boolean
  end
end
