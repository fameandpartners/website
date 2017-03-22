module AdminUi
  class RedirectedSearchTermsController < AdminUi::ApplicationController
    def index
      @search_terms = RedirectedSearchTerm.all
      render :index      
    end

    def create
      search_term = RedirectedSearchTerm.new( params[:redirected_search_term] )
      search_term.save
      index
    end
    
  end
end
