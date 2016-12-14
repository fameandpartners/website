module WeddingAtelier
  module ApplicationHelper
    def registration_background_image_class
      current_spree_user.try(:wedding_atelier_signup_step) || 'signup'
    end
  end
end
