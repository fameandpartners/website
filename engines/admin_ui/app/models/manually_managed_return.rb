class ManuallyManagedReturn < ActiveRecord::Base

  belongs_to :spree_order, foreign_key: :spree_order_number, primary_key: :number, class_name: 'Spree::Order'

  belongs_to :item_return

  attr_accessible(*self.new.attributes.keys
                     .reject{|x| %w(id created_at updated_at).include?(x) }
                     .collect(&:to_sym))

end
