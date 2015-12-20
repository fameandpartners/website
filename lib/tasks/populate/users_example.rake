namespace "db" do
  namespace "populate" do
    desc "create users"
    task users: :environment do
      create_user(
          email:    'spree@example.com',
          is_admin: true,
          name:     'Example User',
          password: '123456'
      )
    end
  end
end

def create_user(name:, email:, password:, is_admin: false)
  first_name, last_name           = name.split(' ')
  user                            = Spree::User.new
  user.first_name                 = first_name
  user.last_name                  = last_name
  user.email                      = email
  user.password                   = password
  user.password_confirmation      = password
  user.skip_welcome_email         = true
  user.validate_presence_of_phone = false
  user.save
  user.spree_roles << Spree::Role.find_by_name('admin') if is_admin
end
