namespace "db" do
  namespace "populate" do
    desc "create users"
    task users: :environment do
      create_user('Example User',   'spree@example.com', true)
      create_user('Evgeniy Petrov', 'malleus.petrov@gmail.com', true)
      create_user('Garrow Bedrossian', 'garrowb@fameandpartners.com', true)
    end
  end
end

def create_user(name, email, is_admin = false)
  first_name, last_name = name.split(' ')
  user = Spree::User.new
  user.first_name = first_name
  user.last_name = last_name
  user.email = email
  user.password = 'password'
  user.password_confirmation = 'password'
  user.skip_welcome_email = true
  user.validate_presence_of_phone = false
  user.save
  user.spree_roles << Spree::Role.find_by_name('admin') if is_admin
end
