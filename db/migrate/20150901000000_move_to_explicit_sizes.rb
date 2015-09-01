class MoveToExplicitSizes < ActiveRecord::Migration

  def up
    Spree::OptionValue.sizes.each do |option_value|
      new_size  = size_value_to_explicit(option_value.name)
      say "Converting Size #{option_value.name} to #{new_size}"
      option_value.name         = new_size[:name]
      option_value.presentation = new_size[:presentation]
      option_value.save
    end
  end

  def down
    Spree::OptionValue.sizes.each do |option_value|
      old_size  = explicit_size_to_value(option_value.name)
      say "Converting Size #{option_value.name} to #{old_size}"
      option_value.name         = old_size
      option_value.presentation = old_size
      option_value.save
    end
  end

  US_AU_SIZE_DELTA = 4
  private def size_value_to_explicit(size_value)
    return size_value unless (size_value.to_i.to_s == size_value)

    au_size = size_value.to_i + US_AU_SIZE_DELTA

    {
      name: "US#{size_value}/AU#{au_size}",
      presentation: "US #{size_value}/AU #{au_size}",
    }
  end

  private def explicit_size_to_value(size)
    size.split('/').first.tr('US','')
  end


  # Future proof the migration by defining relied upon behaviour.
  module Spree
    def self.table_name_prefix
      'spree_'
    end
    class OptionType < ActiveRecord::Base
      def self.size
        where(name: 'dress-size').first
      end
    end

    class OptionValue < ActiveRecord::Base
      scope :sizes,   -> { where("option_type_id is not null").where(option_type_id: Spree::OptionType.size.try(:id)) }
    end
  end
end
