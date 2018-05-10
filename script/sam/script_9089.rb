tiles = [
  { :product => 'The Brighton Dress',  :color => 'cornflower-blue-heavy-georgette' },
  { :product => 'The Brighton Dress',  :color => 'milano-floral-pale-blue-light-georgette' },
  { :product => 'The Brighton Dress',  :color => 'milano-floral-red-light-georgette' },
  { :product => 'The Tiffany Dress ' , :color => 'red-heavy-georgette' },
  { :product => 'The Tiffany Dress ' , :color => 'lemon-heavy-georgette' },
  { :product => 'The Tiffany Dress ' , :color => 'daint-floral-blue-light-georgette' },
  { :product => 'The Tiffany Dress ' , :color => 'ivory-raised-spot-georgette' },
  { :product => 'The Tiffany Dress ' , :color => 'black-heavy-georgette' },

]

tiles.each do |tile|
  puts "\n\n\n\n"
  puts "#{tile[:product]} #{tile[:color]}"
  all_images = Spree::Product.find_by_name(tile[:product]).images
  images = all_images.select { |x| x.viewable.fabric.name==tile[:color] }
  images.each { |img| puts "  #{img.position} #{img.attachment_file_name} #{img.viewable.fabric.name}" }
  position_of_front_crop = images.select { |img| img.attachment_file_name=~/-front-crop.jpg/ }.first.position
  position_of_crop = images.select { |img| img.attachment_file_name=~/[^t]-crop.jpg/ }.first.position
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
