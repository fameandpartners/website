Spree::Core::Engine.load_seed if defined?(Spree::Core)

user = Spree::User.new
user.first_name = 'John'
user.last_name = 'Doe'
user.email = 'john.doe@userroot.com'
user.password = '123456'
user.password_confirmation = '123456'
user.save
user.spree_roles << Spree::Role.find_by_name('admin')
