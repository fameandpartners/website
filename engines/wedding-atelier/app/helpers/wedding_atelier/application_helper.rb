module WeddingAtelier
  module ApplicationHelper
    def registration_background_image_class
      current_spree_user.try(:wedding_atelier_signup_step) || 'signup'
    end

    def profile_image_path
      if current_spree_user.profile_image.present?
        image_path current_spree_user.profile_image.attachment.url(:mini)
      else
        image_path 'profile-placeholder.jpg'
      end
    end

  end
end
