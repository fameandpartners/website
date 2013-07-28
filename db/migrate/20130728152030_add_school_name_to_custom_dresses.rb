class AddSchoolNameToCustomDresses < ActiveRecord::Migration
  def change
    add_column :custom_dresses, :school_name, :string
  end
end
