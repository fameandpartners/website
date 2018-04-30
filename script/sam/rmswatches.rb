print "\n\n\n\n\n\n\n"
targets = [
  { fabric_name: 'spring-posey-light-georgette', product_name: 'The Ramone Jumpsuit' },
  { fabric_name: 'spring-posey-light-georgette', product_name: 'The Leighton Dress' },
  { fabric_name: 'spring-posey-heavy-georgette', product_name: 'The Kira Dress' },
  { fabric_name: 'spring-posey-heavy-georgette', product_name: 'The Dean Dress' },  
  { fabric_name: 'spring-posey-heavy-georgette', product_name: 'The Dean  Dress' },  
  # batch2
  { fabric_name: 'spring-posey-light-georgette', product_name: 'The Tillie Dress' },  
  { fabric_name: 'spring-posey-light-georgette', product_name: 'The Joanie Dress' },  

]
targets.each do |target|
  puts "DB8 #{target[:product_name]} #{target[:fabric_name]}"
  product = Spree::Product.find_by_name(target[:product_name])
  fabric = Fabric.find_by_name(target[:fabric_name])
  target = FabricsProduct.where(product_id: product.id, fabric_id: fabric.id).first rescue nil
  puts target.inspect
  if !product || !fabric || !target
    puts "DB8   skipping nil\n\n\n\n"
    next
  end

  print "Enter to remove"
  gets
  if !ENV['DRY_RUN']
    target.delete
    puts "DB8   exists check #{FabricsProduct.exists?(target.id).inspect}"
  end
  print "\n\n\n\n"
end
