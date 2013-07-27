module Spree
  module Admin
    class TaxonBannersController < BaseController
      respond_to :html

      def update
        @taxonomy = Spree::Taxonomy.find(params[:taxonomy_id])
        @taxon = Spree::Taxon.find(params[:id])

        @banner = @taxon.banner || @taxon.build_banner

        flash[:success] = flash_message_for(@taxon, :successfully_updated)
        
        if @banner.update_attributes(params[:banner])
          flash[:success] = flash_message_for(@taxon, :successfully_updated)
        else
          flash[:error] = "can't update banner"
        end

        respond_with(@banner) do |format|
          format.html { redirect_to edit_admin_taxonomy_taxon_url(@taxonomy.id, @taxon.id) }
        end
      end
    end
  end
end
