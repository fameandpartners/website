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

    def new_ff
      @feature_flag = FeatureFlag.new
    end

    def create_ff
      @feature_flag = FeatureFlag.new(params[:feature_flag])

      if @feature_flag.valid?
        @feature_flag.save
        redirect_to features_path, notice: "Feature Flag #{@feature_flag.flag} was successfully created as #{@feature_flag.state_string}."
      else
        render "new_ff"
      end
    end

    helper_method def feature_list
      Features.send(:rollout).features
    end

    helper_method def active?(feature)
      Features.active?(feature) ? 'Enabled' : 'Disabled'
    end

    helper_method def button_text(feature)
      active?(feature) == 'Enabled' ? 'Disable' : 'Enable'
    end

    helper_method def button_path(feature)
      active?(feature) == 'Enabled' ? disable_features_path(feature: feature) : enable_features_path(feature: feature)
    end

  end
end
