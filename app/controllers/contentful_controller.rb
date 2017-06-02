class ContentfulController < ApplicationController
  include ContentfulHelper

  layout 'contentful/application'

  def main
    render 'layouts/contentful/main'
  end

end
