class LineItemSizeNormalisation < ActiveRecord::Base
  belongs_to :line_item,   class_name: 'Spree::LineItem'
  belongs_to :old_size,    class_name: 'Spree::OptionValue'
  belongs_to :old_variant, class_name: 'Spree::Variant'
  belongs_to :new_size,    class_name: 'Spree::OptionValue'
  belongs_to :new_variant, class_name: 'Spree::Variant'
  attr_accessible :currency, :messages, :new_size, :old_size_value, :site_version
end
