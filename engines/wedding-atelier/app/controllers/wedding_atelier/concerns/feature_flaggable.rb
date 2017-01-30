module WeddingAtelier
  module Concerns
    module FeatureFlaggable
      extend ActiveSupport::Concern

      included do
        before_filter :check_feature_flag
      end

      private

      def check_feature_flag
        if !Features.active?(:wedding_atelier)
          redirect_to main_app.root_path
        end
      end
    end
  end
end
