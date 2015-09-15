Spree::Role.class_eval do
  has_and_belongs_to_many :users, :join_table => 'spree_roles_users', :class_name => 'Spree::User'
end
