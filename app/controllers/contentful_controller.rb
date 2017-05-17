class ContentfulController < ActionController::Base
  layout 'contentful/application'

  def main
    render 'layouts/contentful/main'
  end
end
