require 'active_record/fixtures'

module Features
  module FixturesHelpers
    def load_customization_fixtures
      fixture_path = File.join(Rails.root, 'engines/wedding-atelier/spec/fixtures')
      models = [
        Spree::Taxonomy,
        Spree::Taxon,
        Spree::OptionType,
        Spree::OptionValue,
        Spree::Product,
        Spree::Variant,
        CustomisationValue,
        ProductColorValue
      ]
      join_tables = ['spree_products_taxons']
      fixture_class_names = models.each_with_object({}){ |m,o| o[m.table_name.to_sym] = m.name }
      fixture_table_names = models.map(&:table_name)
      fixture_table_names += join_tables

      ActiveRecord::Fixtures.create_fixtures(fixture_path, fixture_table_names, fixture_class_names)
    end
  end
end

RSpec.configure do |config|
  config.include Features::FixturesHelpers, type: :feature
end
