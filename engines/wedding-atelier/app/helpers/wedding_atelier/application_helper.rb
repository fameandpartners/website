module WeddingAtelier
  module ApplicationHelper
    def registration_background_image_class
      current_spree_user.try(:wedding_atelier_signup_step) || 'signup'
    end

    def include_header?
      !['registrations', 'sessions', 'event_dresses'].include?(controller_name)
    end

    def bot_profile_photo_path
      image_path 'bot-profile.svg'
    end

    def profile_image_path
      if current_spree_user.profile_image.present?
        image_path current_spree_user.profile_image.attachment.url(:mini)
      else
        image_path 'profile-placeholder.jpg'
      end
    end

    def profile_image_tag
      image_tag profile_image_path, class: 'profile-image'
    end

  end
end
