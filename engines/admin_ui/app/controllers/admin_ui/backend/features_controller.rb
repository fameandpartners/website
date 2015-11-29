module AdminUi
  module Backend
    class FeaturesController < AdminUi::ApplicationController
      def index
      end

      helper_method def feature_list
        Features.send(:rollout).features
      end

      helper_method def feature_states
        feature_list.group_by{|x| Features.active?(x) ? 'Enabled' : 'Disabled' }
      end

      helper_method def user_overridden_features
        feature_list
          .select { |x| Features.active?(x) != Features.active?(x, overriding_user) }
          .group_by { |x| Features.active?(x, overriding_user) ? 'Enabled' : 'Disabled' }
      end

      helper_method def overriding_user
        current_admin_user
      end
    end
  end
end
