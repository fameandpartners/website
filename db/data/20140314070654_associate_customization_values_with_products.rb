class AssociateCustomizationValuesWithProducts < ActiveRecord::Migration
  def self.up
    connection = ActiveRecord::Base.connection

    CustomisationValue.all.each do |customisation_value|
      result = connection.execute("SELECT product_id FROM product_customisation_values WHERE customisation_value_id = #{customisation_value.id}")
      product_ids = result.column_values(0).map(&:to_i)

      customisation_value.update_column(:product_id, product_ids.shift)

      product_ids.each do |product_id|
        CustomisationValue.create do |object|
          object.product_id = product_id
          object.name = customisation_value.name
          object.presentation = customisation_value.presentation
          object.position = customisation_value.position
          object.price = customisation_value.price
        end
      end
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end
