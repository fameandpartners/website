module AdminUi
  class RedirectedSearchTermsController < AdminUi::ApplicationController
    def index
      @search_terms = RedirectedSearchTerm.all
      render :index      
    end

    def create
      search_term = RedirectedSearchTerm.new( params[:redirected_search_term] )
      if( search_term.save )
        flash[:success] = 'New Redirect Added'
      else
        flash[:error] = 'Failed'
      end
      index
    end
    
  end
end
