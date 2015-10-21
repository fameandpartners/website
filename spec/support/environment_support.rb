module EnvironmentHelpers

  # data helpers
  def update_elastic_index
    # two steps for easier debug
    Products::ColorVariantsIndexer.new.tap do |indexer|
      indexer.collect_variants
      indexer.push_to_index
    end
  end

  def clean_old_test_data
    Spree::Image.delete_all
    Spree::Product.destroy_all
    Spree::Taxon.delete_all
    Spree::Taxonomy.delete_all

    Spree::OptionType.delete_all
    Spree::OptionValue.delete_all

    Spree::State.delete_all
    Spree::Country.delete_all
    Spree::ZoneMember.delete_all

    Spree::PaymentMethod.delete_all

    Spree::Product.destroy_all
  end

  def ensure_environment_set(options = {})
    Rails.cache.clear
    clean_old_test_data if options[:force]

    models = %w{site_versions taxonomy product_options shipping countries payments}

    unless options[:all]
      if options[:only]
        models = models && options[:only].map{|s| s.to_s.downcase}
      end

      if options[:except]
        models = models - options[:only]
      end
    end

    if models.include?('site_versions')
      create(:site_version, :au) unless SiteVersion.where(permalink: 'au').exists? 
      create(:site_version, :us) unless SiteVersion.where(permalink: 'us').exists? 
    end

    if models.include?('taxonomy')
      taxonomy = build(:taxonomy, :collection)
      taxonomy.save unless Spree::Taxonomy.where(name: taxonomy.name).exists?

      taxonomy = build(:taxonomy, :style)
      taxonomy.save unless Spree::Taxonomy.where(name: taxonomy.name).exists?

      unless Spree::Taxon.where(name: 'Plus Size').exists?
        style_taxonomy = Spree::Taxonomy.where(name: 'Style').first
        style_taxonomy.root.children << create(:taxon, name: 'Plus Size', taxonomy_id: style_taxonomy.id)
      end

      Repositories::Taxonomy.read_all(force: true)
    end

    if models.include?('product_options')
      option_type = Spree::OptionType.where(name: 'dress-size').first
      if option_type.blank? || option_type.option_values.blank?
        create(:option_type, :size, :with_values)
      end

      option_type = Spree::OptionType.where(name: 'dress-color').first
      if option_type.blank? || option_type.option_values.blank?
        create(:option_type, :color, :with_values_groups)
      end

      Repositories::ProductColors.instance_variable_set('@color_groups', nil)
      Spree::Variant.instance_variable_set('@size_option_type', nil)
      Spree::Variant.instance_variable_set('@color_option_type', nil)
    end

    if models.include?('shipping')
      if Spree::ShippingMethod.count == 0
        create(:shipping_method)
      end
    end

    if models.include?('countries')
      Spree::Zone.all.each do |zone|
        Spree::Country.all.each do |country|
          Spree::ZoneMember.where(
            zone_id: zone.id,
            zoneable_type: country.class.to_s,
            zoneable_id: country.id
          ).first_or_create
        end
        zone.reload
      end
    end

    if models.include?('payments')
      create(:pin_gateway)
      create(:masterpass_gateway)


    end
  end

=begin
    create(:taxonomy, :collection)
    create(:taxonomy, :style)
    Repositories::Taxonomy.read_all(force: true)

    create(:option_type, :size, :with_values)
    create(:option_type, :color, :with_values_groups)

    create(:shipping_method)

    create(:state) # spree#state, us country will be created automatically

    create(:pin_gateway) # we need to recreate

    product = create(:spree_product, :with_size_color_variants, position: 1)
    product.reload
=end
end

RSpec.configure do |config|
  config.include EnvironmentHelpers
end
