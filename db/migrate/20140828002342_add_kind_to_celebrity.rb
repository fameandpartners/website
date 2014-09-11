class AddKindToCelebrity < ActiveRecord::Migration
  def change
    add_column :celebrities, :kind, :string, default: 'celebrity'
  end
end
