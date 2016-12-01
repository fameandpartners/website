module WeddingAtelier
  module ApplicationHelper

    def registration?
      controller_name == 'registrations'
    end

    def registration_background_image_class
      current_spree_user.try(:wedding_atelier_signup_step) || 'signup'
    end

  end
end
