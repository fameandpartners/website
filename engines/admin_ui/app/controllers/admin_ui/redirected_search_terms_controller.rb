module AdminUi
  class RedirectedSearchTermsController < AdminUi::ApplicationController
    def index
      @search_terms = RedirectedSearchTerm.all
    end
  end
end
