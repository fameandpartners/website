module Concerns
  module Webpack
  extend ActiveSupport::Concern

  def webpack_assets
    Rails.cache.fetch(env["ORIGINAL_FULLPATH"].to_s+current_site_version.name, expires_in: 14.hours) do
      begin
        resp = RestClient.get "#{configatron.node_pdp_url}/webpack/asset-manifest"
        JSON.parse(resp)
      rescue Exception => e
        Raven.capture_exception(e, response: resp)
        NewRelic::Agent.notice_error(e, response: resp)
        throw e
      end
    end
  end

  end
end
