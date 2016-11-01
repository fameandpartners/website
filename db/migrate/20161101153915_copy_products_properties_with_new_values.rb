class CopyProductsPropertiesWithNewValues < ActiveRecord::Migration
  def up
    patterns_collection = [
      { name: 'fabric', pattern: 'Trim:' },
      { name: 'fit', pattern: 'These measurement are taken from size' }
    ]

    patterns_collections.each do |hash|
      Spree::Property.find_by_name(hash[:name]).product_properties.where('value LIKE ?', "%#{hash[:pattern]}%").find_each do |property|
        product = property.product
        property.product.duplicate.tap do |duplicate|
          duplicate.hidden = true
          duplicate.save!
        end

        property.update_attribute(value: property.value.gsub(/(\n?)(#{hash[:pattern]}.+)/, ''))
        product.touch
      end
    end
  end

  def down
    properties = ['fabric', 'fit']
    pattern = /COPY OF/

    Spree::Product.where('name LIKE ?', "#{pattern}%").where(hidden: true).find_each do |duplicate|
      if product_name = duplicate.name[/#{'COPY OF '}(.+)/,1]
        product = Spree::Product.where(name: product_name)

        properties.each do |name|
          product.set_property(name, duplicate.property(name))
          product.touch
        end

        duplicate.destroy
      end
    end
  end
end
