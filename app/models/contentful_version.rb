class ContentfulVersion < ActiveRecord::Base
  has_one: :user, :class_name => Spree::User    
end
