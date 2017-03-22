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

    def destroy
      search_term = RedirectedSearchTerm.find( params[:id] )
      if( search_term )
        if( search_term.destroy )
          flash[:success] = 'Redirect Removed'
        else
          flash[:error] = search_term.errors.full_messages.to_sentence
        end
      else
        flash[:error] = "Unknown Redirect to Delete"
      end
      redirect_to action: :index
    end
    
  end
end
