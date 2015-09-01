class AddStiForOptionValues < ActiveRecord::Migration
  def up
    add_column :spree_option_values, 'type', :string
    assign_type_to_option_values
  end

  def down
    remove_column :spree_option_values, 'type'
  end

  private

    def assign_type_to_option_values
      Spree::OptionValue.update_all(type: Spree::OptionValue.to_s)

      if Spree::OptionType.color
        Spree::OptionValue.colors.update_all(type: Spree::OptionValue::ProductColor.to_s)
      end
      if Spree::OptionType.size
        Spree::OptionValue.sizes.update_all(type: Spree::OptionValue::ProductSize.to_s)
      end
    end
end
