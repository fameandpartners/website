

print "\n"*8
puts "Fixes for Greer Jumpsuit"
to_be_deleted = Spree::Product.find_by_name("The Greer Jumpsuit").images.where("attachment_file_name LIKE '%l4%'")
to_be_deleted.each do |tbd| puts "Will delete #{tbd.inspect[0..65]}" end
print "Continue?"
gets
to_be_deleted.each do |tbd|
  print "Press enter to delete #{tbd.inspect[0..60]}"
  tbd.delete
  gets
end

print "\n"*8
puts "Fixes for Kiev Dress"
to_be_deleted = Spree::Product.find_by_name("The Kiev Dress").images.where("attachment_file_name LIKE '%mws22%'")
to_be_deleted.each do |tbd| puts "Will delete #{tbd.inspect[0..65]}" end
print "Continue?"
gets
to_be_deleted.each do |tbd|
  print "Press enter to delete #{tbd.inspect[0..60]}"
  tbd.delete
  gets
end

print "\n"*8
puts "Fixes for Surreal Dreamer"

to_be_deleted = Spree::Product.find_by_name("Surreal Dreamer").images.where("attachment_file_name LIKE '%-hg1%'")
to_be_deleted.each do |tbd| puts "Will delete #{tbd.inspect[0..65]}" end
print "Continue?"
gets
result = Spree::Product.find_by_name("Surreal Dreamer").images.where("attachment_file_name LIKE '%-hg1%'").delete_all
puts "ret val was #{result.inspect}"


