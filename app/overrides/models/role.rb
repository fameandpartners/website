Spree::Role.class_eval do
  has_and_belongs_to_many :users, :join_table => 'spree_roles_users', :class_name => 'Spree::User'
  attr_accessible :all # needed until we upgrade to rails 4 in order to mass assign roles to users
end
