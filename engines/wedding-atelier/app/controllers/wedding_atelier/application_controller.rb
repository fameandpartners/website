module WeddingAtelier
  class ApplicationController < ::ApplicationController
    include WeddingAtelier::Concerns::FeatureFlaggable

    layout 'wedding_atelier/application'
    before_filter :authenticate_spree_user!
    before_filter :check_signup_completeness
    serialization_scope :view_context

    def check_signup_completeness
      if current_spree_user && !current_spree_user.wedding_atelier_signup_complete?
        redirect_to controller: :registrations, action: current_spree_user.wedding_atelier_signup_step
      end
    end
  end
end
