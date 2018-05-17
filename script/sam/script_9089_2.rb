puts "\n"*3

items = [
  { :name => 'The Lou Dress', :fabric => 'butterscotch' },
  { :name => 'The Cameron Dress', :fabric => 'cobalt' },
  { :name => 'The Cameron Dress', :fabric => 'pale-blue' },
  { :name => 'The Fairfax Dress', :fabric => 'black' },
  { :name => 'Alija',             :fabric => 'pale-blue' },
  { :name => 'Tilbury Dress',     :fabric => 'pale-blue' },
  { :name => 'Tilbury Dress',     :fabric => 'champagne' },
  { :name => 'Tilbury Dress',      :fabric => 'spring-posey' },
  { :name => 'The Callais Dress',   :fabric => 'burgundy' },
  { :name => 'Paradise Dream',   :fabric => 'burgundy' },
  { :name => 'Allegra',   :fabric => 'navy' },
  { :name => 'Stella',   :fabric => 'peach' },
  { :name => 'Stella',   :fabric => 'pale-gray' },
  { :name => 'Allegra',   :fabric => 'sand' },
  { :name => 'Allegra',   :fabric => 'pale-pink' },
  { :name => 'Allegra',   :fabric => 'pale-gray' },
  { :name => 'Larissa',   :fabric => 'forest-green' },

  # Older dresses
  #{ :name => 'The Sawyer Dress', :fabric => 'BLACK_AND_TAN_SPOT' },
  #{ :name => 'The Amelia Dress', :fabric => 'white' },
  #http://localhost:3000/dresses/dress-the-virgo-1360?color=black
  #http://localhost:3000/dresses/dress-the-pegasus-1336?color=navy
  #http://localhost:3000/dresses/dress-maisie-dress-1290?color=red

  # Weird ones
  #Tile should not be there / Something weird going on / Too many imgs prob
  #http://localhost:3000/dresses/dress-the-lou-dress-1652?color=butterscotch
  #http://localhost:3000/dresses/dress-the-cameron-dress-1648?color=cobalt
  #http://localhost:3000/dresses/dress-the-cameron-dress-1648?color=pale-blue
  #http://localhost:3000/dresses/dress-the-fairfax-dress-1646?color=black
  #http://localhost:3000/dresses/dress-the-sawyer-dress-1628?color=black-and-tan-spot
  #http://localhost:3000/dresses/dress-the-amelia-dress-1543?color=white
  #http://localhost:3000/dresses/dress-the-virgo-1360?color=black
  #http://localhost:3000/dresses/dress-the-pegasus-1336?color=navy
  #http://localhost:3000/dresses/dress-maisie-dress-1290?color=red
  #http://localhost:3000/dresses/dress-alija-1288?color=pale-blue
  #http://localhost:3000/dresses/dress-tilbury-dress-1109?color=pale-blue
  #http://localhost:3000/dresses/dress-tilbury-dress-1109?color=champagne
  #http://localhost:3000/dresses/dress-tilbury-dress-1109?color=spring-posey
  #http://localhost:3000/dresses/dress-the-callais-dress-1064?color=burgundy
  #http://localhost:3000/dresses/dress-ziv-1037?color=champagne
  #http://localhost:3000/dresses/dress-leo-dress-919?color=red
  #http://localhost:3000/dresses/dress-gillian-two-piece-909?color=mint
  #http://localhost:3000/dresses/dress-paradise-dream-380?color=burgundy
  #http://localhost:3000/dresses/dress-allegra-680?color=navy #ffnames
  #http://localhost:3000/dresses/dress-stella-635?color=peach #ffnames
  #http://localhost:3000/dresses/dress-stella-635?color=pale-grey #ffnames
  #http://localhost:3000/dresses/dress-allegra-680?color=sand
  #http://localhost:3000/dresses/dress-allegra-680?color=pale-pink
  #http://localhost:3000/dresses/dress-allegra-680?color=pale-grey
  #http://localhost:3000/dresses/dress-larissa-689?color=forest-green
  #http://localhost:3000/dresses/dress-the-cher-dress-1704?color=lilac-light-silk-charmeuse # Needs images
  #http://localhost:3000/dresses/dress-the-millie-dress-1666?color=lilac-stretch-crepe # No front crop image found

]

nb_fixed = 0
items.each do |item|
  puts "#{item[:name]} #{item[:fabric]}"
  spree_product = Spree::Product.find_by_name(item[:name])
  product = Spree::Product.find_by_name(item[:name])

  images = FabricsProduct.where(product_id: product.id).select { |x| x.fabric.name==item[:fabric] }.first.images rescue nil
  binding.pry if !product
  if !images && (product.images.pluck(:attachment_file_name).map { |x| x=~/-(.*?)-/ && $1 }.uniq.size) > 1
    images = FabricsProduct.where(product_id: product.id).select { |x| x.fabric.name=~/#{item[:fabric]}/ }.first.images rescue nil
  end
  images = product.images if !images

  images.each { |x| puts "  #{x.position} #{x.attachment_file_name}" }
  front_crop_image = images.select { |img| img.attachment_file_name=~/-front-[cd]rop.jpg/i }.first
  binding.pry if !front_crop_image
  front_crop_image_position = front_crop_image.position
  crop_image = images.select { |img| img.attachment_file_name=~/[^t]-crop.jpg/i }.first
  crop_image_position = crop_image.position

  faulty = crop_image_position < front_crop_image_position
  if faulty
    print "  fix? "
    gets
    front_crop_image.update_column(:position, crop_image_position)
    crop_image.update_column(:position, front_crop_image_position)
    puts "  fixed\n"
    nb_fixed = nb_fixed + 1
  else
    puts "  Looks ok"
    sleep 0.1
  end

end

puts "\n Total #{nb_fixed}"
puts "\n"*3
