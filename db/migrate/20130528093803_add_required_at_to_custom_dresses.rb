class AddRequiredAtToCustomDresses < ActiveRecord::Migration
  def change
    add_column :custom_dresses, :required_at, :date
  end
end
