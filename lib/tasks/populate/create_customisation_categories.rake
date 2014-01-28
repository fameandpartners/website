namespace "db" do
  namespace "populate" do
    desc "create Length/NeckLine customisation categories"
    task customisation_categories: :environment do
      customisations = [
        {name: 'length', values: %w[short mid-length high]},
        {name: 'neck-line', values: %w[vneck round straight]}
      ]
      customisations.each do |attrs|
        attrs[:presentation] ||= attrs[:name].underscore.humanize.split.map(&:capitalize).join(' ')
        values = attrs.delete(:values)
        category = CustomisationType.where(attrs).first_or_create
        (values - category.customisation_values.map(&:name)).each do |name|
          presentation = name.underscore.humanize.split.map(&:capitalize).join(' ')
          category.customisation_values.create(name: name, presentation: presentation)
        end
      end
    end

    desc "bootstrap customisation [dev only]"
    task bootstrap_customisation: :environment do
      if true
        ProductCustomisationValue.delete_all
        ProductCustomisationType.delete_all
        CustomisationValue.delete_all
        CustomisationType.delete_all
      end

      customisations = [
        {name: 'length', values: %w[short mid-length high]},
        {name: 'neck-line', values: %w[vneck round straight]},
        {name: 'waist-line', values: %w[vneck round straight]},
        {name: 'hem-line', values: %w[vneck round straight]}
      ]
      customisations.each do |attrs|
        populate_type_with_values(attrs[:name], attrs[:values])
      end

      Spree::Product.all.each do |product|
        bootstrap_product_with_customisations(product)
      end
    end
  end

  def populate_type_with_values(name, values)
    presentation = name.underscore.humanize.split.map(&:capitalize).join(' ')
    category = CustomisationType.where(name: name, presentation: presentation).first_or_create
    (values - category.customisation_values.map(&:name)).each do |name|
      presentation = name.underscore.humanize.split.map(&:capitalize).join(' ')
      category.customisation_values.create(name: name, presentation: presentation)
    end
  end

  def bootstrap_product_with_customisations(product)
    CustomisationType.all.each do |custom_type|
      product_custom_type = product.product_customisation_types.where(customisation_type_id: custom_type.id).first_or_create

      custom_type.customisation_values.all.each do |custom_value|
        product.product_customisation_values.where(
          product_customisation_type_id: product_custom_type.id,
          customisation_value_id: custom_value.id
        ).first_or_create
      end
    end
  end
end
