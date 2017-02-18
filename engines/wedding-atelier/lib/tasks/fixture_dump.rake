namespace :wedding_atelier do
  namespace :fixtures do
    desc 'Dumps all models into fixtures.'
    task :dump => :environment do
      sql  = "SELECT * FROM %s"
      tables = [
       "spree_taxonomies",
       "spree_taxons",
       "spree_option_types",
       "spree_option_values",
       "spree_products",
       "spree_products_taxons",
       "spree_variants",
       "customisation_values",
       "product_color_values"
      ]

      ActiveRecord::Base.establish_connection(Rails.env)
      (tables).each do |table_name|
        file = File.open("#{Rails.root}/engines/wedding-atelier/spec/fixtures/#{table_name}.yml", 'w')
        data = ActiveRecord::Base.connection.select_all(sql % table_name)
        output = {}
        data.each_with_index do |record, i|
          output["#{table_name}_#{i}"] = record.delete_if{|k,v| v.nil? }
        end
        file << output.to_yaml
        file.close
      end
    end
  end
end
