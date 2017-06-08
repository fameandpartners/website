class ContentfulVersion < ActiveRecord::Base
  paginates_per 20
  serialize :contentful_payload

  has_one :user, :class_name => Spree::User    
end
