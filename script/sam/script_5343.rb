
print "\n"*8
to_be_deleted = Spree::Product.find_by_name("The Greer Jumpsuit").images.where("attachment_file_name LIKE '%l4%'")
to_be_deleted.each do |tbd| puts "Will delete #{tbd.inspect[0..65]}" end
print "Continue?"
gets
to_be_deleted.each do |tbd|
  puts "Press enter to delete #{tbd.inspect[0..60]}"
  gets
end

