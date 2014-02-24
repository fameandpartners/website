class AddTitleQuoteDescriptionToCelebrities < ActiveRecord::Migration
  def change
    add_column :celebrities, :title,        :string, limit: 255
    add_column :celebrities, :quote,        :string, limit: 512
    add_column :celebrities, :body,         :text
  end
end
