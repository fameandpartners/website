namespace :data do
  desc 'Migrate product customizations to json column'
  task :create_curations => :environment do
    Spree::Image.find_each do |image|
      if image.viewable_type == 'Spree::Variant'
        next
      elsif image.viewable_type == 'ProductColorValue'
        color_or_fabric = image.viewable.option_value.name
        product = image.viewable.product
      elsif image.viewable_type == 'FabricsProduct'
        product = image.viewable.product
        color_or_fabric = image.viewable.fabric.name
      elsif image.viewable_type == 'Curation'
        next
      elsif image.viewable_type == 'Spree::User'
        next
      else
        raise 'unknown viewable type'
      end

      pid = Spree::Product.format_new_pid(
        product.sku,
        color_or_fabric,
        []
      )

      curation = Curation.find_or_create_by_pid_and_product_id(pid, product.id)
      curation.active = true
      curation.save

      image.viewable = curation
      image.save
    end
  end
end