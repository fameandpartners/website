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
        flash[:error] = search_term.errors.full_messages.to_sentence
      end
      index
    end
    
  end
end
