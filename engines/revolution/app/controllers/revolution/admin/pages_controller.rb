module Revolution
  class PagesController < AdminUiApplicationController::Base
    attr_accessor :pages
    helper_method :pages

    def index
      @pages = Page.order(:path => 'desc')
    end

    def show
    end

  end
end
