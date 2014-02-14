class CustomisationFixes < ActiveRecord::Migration
  def up
    if !ActiveRecord::Base.connection.column_exists?(:product_customisation_values, :product_id)
      add_column :product_customisation_values, :product_id, :integer
    end
    if !ActiveRecord::Base.connection.column_exists?(:product_customisation_values, :name)
      add_column :product_customisation_values, :name, :string
    end
    if !ActiveRecord::Base.connection.column_exists?(:product_customisation_values, :presentation)
      add_column :product_customisation_values, :presentation, :string
    end
  end

  def down
    if ActiveRecord::Base.connection.column_exists?(:product_customisation_values, :product_id)
      remove_column :product_customisation_values, :product_id
    end
    if ActiveRecord::Base.connection.column_exists?(:product_customisation_values, :name)
      remove_column :product_customisation_values, :name
    end
    if ActiveRecord::Base.connection.column_exists?(:product_customisation_values, :presentation)
      remove_column :product_customisation_values, :presentation
    end
  end
end
