module Spree
  module WeddingAtelier
    class BaseController < ApplicationController
      layout 'wedding_atelier'
      before_filter :authenticate_spree_user!
      before_filter :check_signup_completeness
      helper SpreeWeddingAtelier::Engine.helpers

      def check_signup_completeness
        if current_spree_user && !current_spree_user.wedding_atelier_signup_complete?
          redirect_to controller: :registrations, action: current_spree_user.wedding_atelier_signup_step
        end
      end
    end
  end
end
