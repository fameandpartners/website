tiles = [
  # Halfish
  ##{ :product => 'Paradise Dream', :color => 'burgundy' },
  ##{ :product => 'The Ada Dress' , :color => 'light-nude' },

  # Funky filenames
  ##{ :product => 'Stella' , :color => 'peach' },
  ##{ :product => 'Stella' , :color => 'pale-gray' },
  ##{ :product => 'Olsen' , :color => 'navy' },

  # Too many
  ##{ :product => 'Allegra' , :color => 'navy' },
  ##{ :product => 'Megan' , :color => 'black' },
  ##{ :product => 'Leo Dress' , :color => 'black' },
  ##{ :product => 'Leo Dress' , :color => 'red' },
  ## { :product => 'Ziv' , :color => 'taupe' },
  ##{ :product => 'The Callais Dress' , :color => 'burgundy' },
  ##{ :product => 'Tilbury Dress' , :color => 'pale-blue' },
  ##{ :product => 'Tilbury Dress' , :color => 'champagne' },
  ##{ :product => 'Tilbury Dress' , :color => 'spring-posey' },
  ##{ :product => 'Alija' , :color => 'pale-blue' },
  ##{ :product => 'Maisie Dress' , :color => 'red' },
  ##{ :product => 'The Pegasus' , :color => 'navy' },
  ##{ :product => 'The Virgo' , :color => 'dark-tan' },
  ##{ :product => 'The Virgo' , :color => 'black' },
  ##{ :product => 'The Amelia Dress' , :color => 'white' },
  ##{ :product => 'The Sawyer Dress' , :color => 'black-and-tan-spot' },
  ##{ :product => 'The Fairfax Dress' , :color => 'black' },
  ## { :product => 'The Cameron Dress' , :color => 'pale-blue' },
  ## { :product => 'The Cameron Dress' , :color => 'cobalt' },

  # Wont hover
  # /dresses/dress-the-tate-dress-1120?color=pastel-garden
  # /dresses/dress-maisie-dress-1290?color=black
  # /dresses/dress-the-millie-dress-1666?color=lilac-stretch-crepe

  # Must inv.
  ##{ :product => 'Larissa' , :color => 'forest-green' },
  ##{ :product => 'Gillian Two Piece' , :color => 'mint' },
  ##{ :product => 'Gillian Two Piece' , :color => 'black' },

  { :product => 'Valerie' , :color => 'black' },
  { :product => 'Summer Angel' , :color => 'pale-blue' },
  { :product => 'Dragon Eyes Lace' , :color => 'burgundy' },
  { :product => 'Agata Dress' , :color => 'cobalt-blue' },
  { :product => 'Zephyra Dress' , :color => 'dark-tan' },
  { :product => 'Antares' , :color => 'red' },
  { :product => 'The Pisces' , :color => 'black' },
  { :product => 'The Axis' , :color => 'pretty-pink' },
  { :product => 'The Celestine' , :color => 'black' },
  { :product => 'The Equinox' , :color => 'black' },
  { :product => 'The Wilton Dress' , :color => 'black' },
  { :product => 'The Vista Dress' , :color => 'black' },
  { :product => 'The Bluth Dress' , :color => 'navy' },
  { :product => 'The Diaz Dress' , :color => 'lemon' },
  { :product => 'The Micah Dress' , :color => 'red-stretch-crepe' },
  { :product => 'The Gower Dress' , :color => 'dark-tan-matte-satin' },
  { :product => 'The Zarita Dress' , :color => 'navy-matte-satin' },
  { :product => 'The Lara Dress' , :color => 'lemon-heavy-georgette' },
  { :product => 'The Vionna Dress' , :color => 'red-heavy-georgette' },
  { :product => 'The Cynthia Dress' , :color => 'red-heavy-georgette' },
  { :product => 'The Nancy Dress' , :color => 'ivory-raised-spot-georgette' },
  { :product => 'The Sylvan Dress' , :color => 'ivory-raised-spot-georgette' },
  { :product => 'The Ollie Dress' , :color => 'burgundy-light-georgette' },
  { :product => 'The Maeva Dress' , :color => 'blue-violet-line' },
  { :product => 'The Gable Dress' , :color => 'ice-grey-linen' },
  { :product => 'The Babette Dress' , :color => 'black-heavy-stretch-linen' },
  { :product => 'The Rori Dress ' , :color => 'seasame-heavy-stretch-linen' },
  { :product => 'The Marisol Dress ' , :color => 'ivory-heavy-stretch-linen' },
  { :product => 'The Riley Dress' , :color => 'ivory-cotton-poplin-stripe' },
]

tiles.each do |tile|
  puts "\n\n\n\n"
  puts "#{tile[:product]} #{tile[:color]}"
  all_images = Spree::Product.find_by_name(tile[:product]).images
  images = all_images
  images.each { |img| puts "  #{img.position} #{img.attachment_file_name}" }
  position_of_front_crop = images.select { |img| img.attachment_file_name=~/-front-crop.jpg/i }.first.position
  position_of_crop = images.select { |img| img.attachment_file_name=~/[^t]-crop.jpg/i }.first.position
  faulty = position_of_crop < position_of_front_crop
  if faulty
    puts "  Will fix"
  else
    puts "  Looks ok"
  end
  gets

  if faulty
    a = images.select { |x| x.position==position_of_crop }.first
    b = images.select { |x| x.position==position_of_front_crop }.first
    a.update_column(:position, position_of_front_crop)
    b.update_column(:position, position_of_crop)
  end
  puts "\n\n\n"
end
