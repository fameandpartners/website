module Concerns
  module Webpack
  extend ActiveSupport::Concern

  def contentful_global_page_config
    Rails.cache.fetch("contentful_global_page_config-#{current_site_version.name}", expires_in: 14.hours) do
      begin
        resp = RestClient.get(
          "#{configatron.fame_webclient_url}/_webclient/cms/entry?field=slug&contentType=pageSettings&value=global-page&siteVersion=#{current_site_version.is_australia? ? 'en-AU' : 'en-US'}"
        )
        JSON.parse(resp)
      rescue Exception => e
        Raven.capture_exception(e, extra: { response: resp })
        throw e
      end
    end
  end

  end
end
