puts "-" * 100
puts "sorry, but seeds for this project obsoleted hundreds years ago"
puts "-" * 100
=begin
Spree::Core::Engine.load_seed if defined?(Spree::Core)

user = Spree::User.where(email: 'user@example.com').first_or_initialize
user.first_name = 'John'
user.last_name = 'Doe'
user.password = 'password'
user.password_confirmation = 'password'
user.save!
puts "User user@example.com/password created"

user = Spree::User.new
user.first_name = 'John'
user.last_name = 'Doe'
user.email = 'admin@example.com'
user.password = 'password'
user.password_confirmation = 'password'
user.save
user.spree_roles << Spree::Role.find_by_name('admin')
puts "Admin User admin@example.com/password created"
=end
