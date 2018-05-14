puts "\n"*3

items = [
  # New Era fabric dresses
  { :name => 'The Brighton Dress', :fabric => 'cornflower-blue-heavy-georgette' },
  { :name => 'The Brighton Dress', :fabric => 'milano-floral-pale-blue-light-georgette' },
  { :name => 'The Brighton Dress', :fabric => 'milano-floral-red-light-georgette' },
  { :name => 'The Brighton Dress', :fabric => 'ivory-raised-spot-georgette' },
  { :name => 'The Brighton Dress', :fabric => 'black-heavy-georgette' },
  { :name => 'The Tiffany Dress ', :fabric => 'red-heavy-georgette' },
  { :name => 'The Tiffany Dress ', :fabric => 'lemon-heavy-georgette' },
  { :name => 'The Tiffany Dress ', :fabric => 'daint-floral-blue-light-georgette' },
  { :name => 'The Tiffany Dress ', :fabric => 'ivory-raised-spot-georgette' },
  { :name => 'The Tiffany Dress ', :fabric => 'black-heavy-georgette' },
  { :name => 'The Penelope Dress', :fabric => 'milano-floral-red-light-georgette' },
  { :name => 'The Penelope Dress', :fabric => 'cornflower-blue-heavy-georgette' },
  { :name => 'The Penelope Dress', :fabric => 'blush-heavy-georgette' },
  { :name => 'The Penelope Dress', :fabric => 'blush-light-georgette' },
  { :name => 'The Penelope Dress', :fabric => 'milano-floral-pale-blue-light-georgette' },
  { :name => 'The Phoebe Dress',    :fabric => 'milano-floral-red-stretch-crepe' },
  { :name => 'The Ellison Dress ',    :fabric => 'black-stretch-crepe' },
  { :name => 'The Ellison Dress ',    :fabric => 'lemon-stretch-crepe' },
  { :name => 'The Ellison Dress ',    :fabric => 'milano-floral-pale-pink-stretch-crepe' },
  { :name => 'The Ellison Dress ',    :fabric => 'sesame-heavy-stretch-linen' },
  { :name => 'The Riley Dress',    :fabric => 'ivory-cotton-poplin-stripe' },
  { :name => 'The Marisol Dress ',    :fabric => 'ivory-heavy-stretch-linen' },
  { :name => 'The Rori Dress ',    :fabric => 'sesame-heavy-stretch-linen' },
  { :name => 'The Babette Dress',    :fabric => 'black-heavy-stretch-linen' },
  { :name => 'The Gable Dress',    :fabric => 'ice-grey-linen' },
  { :name => 'The Maeva Dress',    :fabric => 'blue-violet-linen' },
  { :name => 'The Ollie Dress',    :fabric => 'burgundy-light-georgette' },
  { :name => 'The Max Dress',    :fabric => 'lilac-corded-lace' },
  { :name => 'The Sylvan Dress',    :fabric => 'ivory-raised-spot-georgette' },
  { :name => 'The Zurich Dress',    :fabric => 'bubblegum-pink-medium-silk-charmeuse' },
  { :name => 'The Zurich Dress',    :fabric => 'black-light-silk-charmeuse' },
  { :name => 'The Zurich Dress',    :fabric => 'bordeaux-light-silk-charmeuse' },
  { :name => 'The Terry Dress',    :fabric => 'lilac-medium-silk-charmeuse' },
  { :name => 'The Terry Dress',    :fabric => 'black-spot-on-ivory-stretch-crepe' },
  { :name => 'The Nancy Dress',    :fabric => 'ivory-raised-spot-georgette' },
  { :name => 'The Vionna Dress',    :fabric => 'red-heavy-georgette' },
  { :name => 'The Lara Dress',    :fabric => 'lemon-heavy-georgette' },
  { :name => 'The Zarita Dress',    :fabric => 'navy-matte-satin' },
  { :name => 'The Dean Dress',    :fabric => 'lemon-heavy-georgette' },
  { :name => 'The Dean Dress',    :fabric => 'pastel-garden-heavy-georgette' },
  { :name => 'The Dean Dress',    :fabric => 'aqua-lily-heavy-georgette' },
  { :name => 'The Micah Dress',    :fabric => 'red-stretch-crepe' },
  { :name => 'The Kira Dress',    :fabric => 'hot-pink-heavy-georgette' },
  { :name => 'The Kira Dress',    :fabric => 'black-light-silk-charmeuse' },
  { :name => 'The Kira Dress',    :fabric => 'blue-grey-light-silk-charmeuse' },
  { :name => 'The Kira Dress',    :fabric => 'navy-light-silk-charmeuse' },
  { :name => 'The Kira Dress',    :fabric => 'ice-pink-light-silk-charmeuse' },
  { :name => 'The Kira Dress',    :fabric => 'pretty-pink-heavy-georgette' },

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

  # Older color dresses
  { :name => 'The Diaz Dress',    :fabric => 'lemon' },
  { :name => 'The Bluth Dress',    :fabric => 'navy' },
  { :name => 'The Vista Dress',    :fabric => 'black' },
  { :name => 'The Wilton Dress' , :color => 'black' },
  { :name => 'The Equinox' , :color => 'black' },
  { :name => 'The Celestine' , :color => 'black' },
  { :name => 'The Axis' , :color => 'pretty-pink' },
  { :name => 'The Pisces' , :color => 'black' },
  { :name => 'Antares' , :color => 'red' },
  { :name => 'Zephyra Dress' , :color => 'dark-tan' },
  { :name => 'Agata Dress' , :color => 'cobalt-blue' },
  { :name => 'Dragon Eyes Lace' , :color => 'burgundy' },
  { :name => 'Summer Angel' , :color => 'black' },
  { :name => 'Valerie' , :color => 'black' },

]

nb_fixed = 0
items.each do |item|
  puts "#{item[:name]}"
  spree_product = Spree::Product.find_by_name(item[:name])
  product = Spree::Product.find_by_name(item[:name])

  images = FabricsProduct.where(product_id: product.id).select { |x| x.fabric.name==item[:fabric] }.first.images rescue nil
  binding.pry if !product
  images = product.images if !images


  images.each { |x| puts "  #{x.position} #{x.attachment_file_name}" }
  front_crop_image = images.select { |img| img.attachment_file_name=~/-front-[cd]rop.jpg/i }.first
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
