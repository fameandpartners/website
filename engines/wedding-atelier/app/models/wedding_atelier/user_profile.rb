module WeddingAtelier
  class UserProfile < ActiveRecord::Base
    attr_accessor :skip_validation
    belongs_to :dress_size,
                class_name: 'Spree::OptionValue'

    attr_accessible :spree_user_id,
                    :trend_updates,
                    :height,
                    :dress_size_id,
                    :skip_validation

    belongs_to :spree_user, class_name: Spree.user_class.name
    validates_presence_of :height, :dress_size_id, unless: lambda { self.skip_validation }
  end
end
