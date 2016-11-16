class CopyProductsPropertiesWithNewValues < ActiveRecord::Migration
  def up
    patterns_collections = [
      { name: 'fabric', pattern: 'Trim:' },
      { name: 'fit', pattern: 'These measurement are taken from size' }
    ]

    
    patterns_collections.each do |hash|
      Spree::Property.find_by_name(hash[:name]).product_properties.where('value LIKE ?', "%#{hash[:pattern]}%").find_each do |property|
        product = property.product
        product.set_property("backup-#{hash[:name]}", property.value)
        property.update_attribute(value: property.value.gsub(/(\n?)(#{hash[:pattern]}.+)/, ''))
        product.touch
      end
    end
  end

  def down
    properties = ['fabric', 'fit']

    properties.each do |name|
      Spree::Property.find_by_name("backup-#{name}").product_properties.find_each do |property|
        product = property.product
        product.set_property(name, property.value)
        product.touch
        property.destroy
      end
    end
  end

end
