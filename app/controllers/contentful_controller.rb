class ContentfulController < ApplicationController
  layout 'contentful/application'

  def main
    render 'layouts/contentful/main'
  end
end
