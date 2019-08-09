module AdminUi
  module Backend
    class ProductIndexesController < AdminUi::ApplicationController

      private def index_name
        configatron.elasticsearch.indices.color_variants
      end

      def index
      end

      def clear
        puts("daping start clear index")
        message = if params[:really_really] == 'REALLY'
                    ::NewRelic::Agent.record_custom_event('ClearCacheWorker_web', user: current_admin_user.email)
                    ClearCacheWorker.perform_async
                    { notice: 'Working... ' }
                  else
                    { error: 'Hold your horses!' }
                  end
        redirect_to backend_product_indexes_path, flash: message
      end
    end
  end
end
