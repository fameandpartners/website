module AdminUi
  module Backend
    class CachesController < AdminUi::ApplicationController

      include ActionView::Helpers::TextHelper

      def index
        @servers = Rails.cache.stats
      end

      def expire
        message = if params[:really_expire] == 'EXPIRE'
                    Rails.cache.clear
                    ::NewRelic::Agent.record_custom_event('cache_expire_full', user: current_admin_user.email)

                    'Expired whole cache'
                  else
                    "Didn't Expire"
                  end

        redirect_to backend_caches_path, flash: { notice: message }
      end
    end
  end
end
