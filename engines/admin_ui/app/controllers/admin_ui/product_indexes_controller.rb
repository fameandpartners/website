module AdminUi
  class ProductIndexesController < AdminUi::ApplicationController

    private def index_name
      configatron.elasticsearch.indices.color_variants
    end

    def index
      @search = Tire.search(index_name, size: 2_000) do
        sort { by :'product.name' }
      end
    end

    def show
      if params[:id].present?
        @show_id = params[:id].to_i.to_s
        qry = "id:#{@show_id}"

        @search = Tire.search(index_name) do
          query do
            string qry
          end
        end
      end
    end

    def clear
      message = if params[:really_really] == 'REALLY'
        ::NewRelic::Agent.record_custom_event('ClearCacheWorker_web', user: current_admin_user.email)
        ClearCacheWorker.perform_async(Time.now)
        { notice: "Working... " }
      else
        { error: "Hold your horses!" }
      end
      redirect_to product_indexes_path, flash: message
    end
  end
end
