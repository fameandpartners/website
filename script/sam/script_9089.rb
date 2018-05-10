puts "\n\n\n\n"
print "Larissa "
gets
a = Spree::Product.find_by_name("Larissa").images.find_by_position('6')
b = Spree::Product.find_by_name("Larissa").images.find_by_position('7')
a.update_column(:position, 7)
b.update_column(:position, 6)
puts "fixed"

# Similar logic for.
#   The Callais Dress
#   Summer Angel
# i think.
