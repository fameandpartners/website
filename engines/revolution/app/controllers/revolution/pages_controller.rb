module Revolution
  class PagesController < ::ApplicationController
    attr_reader :page
    helper_method :page

    def show
      @page = Revolution::Page.find_for(request.path)
      render page.template_path
    end

  end
end
