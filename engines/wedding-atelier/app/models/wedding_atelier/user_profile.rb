module WeddingAtelier
  class UserProfile < ActiveRecord::Base
    attr_accessible :spree_user_id,
                    :trend_updates,
                    :height,
                    :dress_size

    belongs_to :spree_user, class_name: Spree.user_class.name
  end
end
