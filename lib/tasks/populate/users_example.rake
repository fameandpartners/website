namespace "db" do
  namespace "populate" do
    desc "create users"
    task users: :environment do
      create_user('Example User',   'spree@example.com', true)
      create_user('Evgeniy Petrov', 'malleus.petrov@gmail.com', true)
    end
  end
end

def create_user(name, email, is_admin = false)
  first_name, last_name = name.split(' ')
  user = Spree::User.new
  user.first_name = first_name
  user.last_name = last_name
  user.email = email
  user.password = '123456'
  user.password_confirmation = '123456'
  user.save
  user.spree_roles << Spree::Role.find_by_name('admin')
end
