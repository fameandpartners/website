class ContentfulVersion < ActiveRecord::Base
  paginates_per 20
  serialize :payload, Hash

  belongs_to :user, :class_name => Spree::User

end
