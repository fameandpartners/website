class ContentfulController < ApplicationController
  # include ContentfulHelper
  # include ContentfulService

  layout 'contentful/application'

  attr_reader :page, :banner
  helper_method :page, :banner


  def main
    current_contently = Contentful::Version.fetch_payload(params['developer'] == 'preview')

    @landing_page_container = current_contently[request.path]

    if @landing_page_container
      landing_page_specific_site_version = @landing_page_container[:site_version]
      landing_page_redirect_to_url = @landing_page_container[:site_version_url_to_redirect]

      # Check if the domain is either AU or US and compare with the flag
      if (landing_page_specific_site_version == 'all' || current_site_version[:permalink] == landing_page_specific_site_version)
        render 'layouts/contentful/main'
      else
        # When the page is specific to a site version redirect user to a different URL (example: AU site vs. US visitor)
        redirect_to landing_page_redirect_to_url, status: 301
      end
    else
      render_404
    end
  end
end
