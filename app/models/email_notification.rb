class EmailNotification < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User', foreign_key: :spree_user_id
end
