class AddEmailToFactory < ActiveRecord::Migration
  def change
    add_column :factories, :production_email, :text
  end
end
