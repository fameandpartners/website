module AdminUi
  class CachesController < AdminUi::ApplicationController

    include ActionView::Helpers::TextHelper
    def index
      @stats = Rails.cache.stats.to_h
      @cache_keys = cache_client.keys.sort
    end

    def destroy
      message = if params[:id].present?
        key     = Base64.urlsafe_decode64(params[:id])
        deleted = cache_client.del(key)

        ::NewRelic::Agent.record_custom_event(
          'cache_expire_item',
          user:           current_admin_user.email,
          item_key:       key,
          deletion_count: deleted
        )
        "Deleted #{pluralize(deleted, 'item')}"
      else
        "Nothing Deleted"
      end

      redirect_to caches_path, flash: {notice: message}
    end

    def show
      if params[:id].present?
        @key  = Base64.urlsafe_decode64(params[:id])
        @data = cache_client.get(@key)
      end
    end

    def expire
      message = if params[:really_expire] == 'EXPIRE'
        deleted = Rails.cache.clear

        ::NewRelic::Agent.record_custom_event(
          'cache_expire_full',
          user:           current_admin_user.email,
          deletion_count: deleted
        )

        "Expired #{pluralize(deleted, 'item')}"
      else
        "Didn't Expire"
      end
      redirect_to caches_path, flash: {notice: message}
    end

    private
    def cache_client
      Rails.cache.instance_variable_get(:@data)
    end
  end
end
