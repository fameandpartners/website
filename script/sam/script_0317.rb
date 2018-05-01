puts "\n\n\n\n"
navy_duchess_satin = Fabric.find_by_name("navy-duchess-satin")
product = Spree::Product.find_by_name("Sarah")
fabrics_product = FabricsProduct.where(product_id: product.id, recommended: true).first
if !ENV['DRY_RUN']
  result = fabrics_product.update_column(:fabric_id, navy_duchess_satin.id)
  puts "DB8 result was #{result.inspect}"
end




