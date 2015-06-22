class AddAvailableOnPathToOptionValuesGroup < ActiveRecord::Migration
  class Spree::OptionValuesGroup < ActiveRecord::Base
  end

  def migrate_data
    %w(black white blue pink red pastel).each do |group_name|
      if group = Spree::OptionValuesGroup.find_by_name(group_name)
        group.available_as_taxon = true
        group.save
      end
    end
  end

  def up
    add_column :spree_option_values_groups, :available_as_taxon, :boolean, default: false
    migrate_data
  end

  def down
    remove_column :spree_option_values_groups, :available_as_taxon
  end
end
