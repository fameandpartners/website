module AdminUi
  module Backend
    class FeaturesController < AdminUi::ApplicationController
      def index
        @collection = FeaturesGrid.new
      end

      def enable
        candidate_feature = params[:feature].to_sym

        Features.activate(candidate_feature)
        redirect_to backend_features_path, notice: "Feature Flag #{candidate_feature} was successfully Enabled."
      end

      def disable
        candidate_feature = params[:feature].to_sym

        Features.deactivate(candidate_feature)
        redirect_to backend_features_path, notice: "Feature Flag #{candidate_feature} was successfully Disabled."
      end
    end
  end
end
