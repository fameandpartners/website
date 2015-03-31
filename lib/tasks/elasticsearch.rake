namespace :elasticsearch do
  desc 'Reindex Elasticsearch, everything'
  task :reindex => :environment do
    Utility::Reindexer.reindex
  end

  desc 'Reindex Colour Variants'
  task :colour_variants => :environment do
    Products::ColorVariantsIndexer.index!
  end

  desc 'Reindex a single product. Supply PRODUCT_ID as an ENV var'
  task :product => :environment do
    product_id = ENV['PRODUCT_ID'].to_i or raise ArgumentError.new("Need PRODUCT_ID Environment variable")
    puts "Reindexing #{product_id}?"
    if (product = Spree::Product.find(product_id))
      product.update_index
      puts "Done"
    end
  end
end
