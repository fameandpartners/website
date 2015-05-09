class CopyFactoryPropertyToAssociation < ActiveRecord::Migration

  class Spree::Product
    belongs_to :factory
  end

  def up
    Spree::Product.where(:factory_id => nil).find_each do |product|
      current_factory_property = product.property(:factory_name)
      # Exclude the old SURRYHILLS "factory"
      if current_factory_property.present? && current_factory_property !~ /surry/i
        print '.'
        product.factory = Factory.find_or_create_by_name(current_factory_property.capitalize)
        product.save
      end
    end
    puts '.'
  end

  def down
    Spree::Product.connection.execute('UPDATE spree_products SET factory_id = NULL')
  end
end
