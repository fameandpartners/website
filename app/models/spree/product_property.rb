module Spree
  class ProductProperty < ActiveRecord::Base

    belongs_to :product
    belongs_to :property

    validates :property, :presence => true
    validates :value, :length => { :maximum => 511 }

    attr_accessible :property_name, :value, :position, :property_id, :product_id

    default_scope :order => "#{self.table_name}.position"

    # virtual attributes for use with AJAX completion stuff
    def property_name
      property.name if property
    end

    def property_name=(name)
      unless name.blank?
        unless property = Property.find_by_name(name)
          property = Property.create(:name => name, :presentation => name)
        end
        self.property = property
      end
    end
  end
end
