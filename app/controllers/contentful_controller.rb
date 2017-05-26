class ContentfulController < ApplicationController
  include ContentfulHelper

  layout 'contentful/application'

  def main
    @landing_page_container = get_contentful_lp_parent_container
    render 'layouts/contentful/main'
  end

end
