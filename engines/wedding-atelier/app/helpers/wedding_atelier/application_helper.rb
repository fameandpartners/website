module WeddingAtelier
  module ApplicationHelper
    def profile_image_url
      if current_spree_user.profile_image.present?
        image_tag current_spree_user.profile_image.attachment.url(:mini), class: 'profile-image'
      else
        image_tag 'profile-placeholder.jpg', class: 'profile-image'
      end
    end
  end
end
