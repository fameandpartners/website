module AdminUi
  module Backend
    class FeaturesController < AdminUi::ApplicationController
      def index
      end

      def enable
        Features.activate(params[:feature])
        redirect_to backend_features_path, notice: "Feature Flag #{params[:feature]} was successfully Enabled."
      end

      def disable
        Features.deactivate(params[:feature])
        redirect_to backend_features_path, notice: "Feature Flag #{params[:feature]} was successfully Disabled."
      end

      helper_method def feature_list
        Features.features
      end

      helper_method def active_text(feature)
        Features.active?(feature) ? 'Enabled' : 'Disabled'
      end

      helper_method def button_text(feature)
        Features.active?(feature) ? 'Disable' : 'Enable'
      end

      helper_method def button_path(feature)
        Features.active?(feature) ? disable_backend_features_path(feature: feature) : enable_backend_features_path(feature: feature)
      end

    end
  end
end