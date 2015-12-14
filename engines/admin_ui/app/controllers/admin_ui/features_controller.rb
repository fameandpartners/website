module AdminUi
  class FeaturesController < AdminUi::ApplicationController
    def index
    end

    def enable
      Features.activate(params[:feature])
      redirect_to features_path, notice: "Feature Flag #{params[:feature]} was successfully Enabled."
    end

    def disable
      Features.deactivate(params[:feature])
      redirect_to features_path, notice: "Feature Flag #{params[:feature]} was successfully Disabled."
    end

    helper_method def feature_list
      Features.features
    end

    helper_method def active_text(feature)
      Features.active?(feature) ? 'Enabled' : 'Disabled'
    end

    helper_method def button_text(feature)
      active_text(feature) == 'Enabled' ? 'Disable' : 'Enable'
    end

    helper_method def button_path(feature)
      active_text(feature) == 'Enabled' ? disable_features_path(feature: feature) : enable_features_path(feature: feature)
    end

  end
end
