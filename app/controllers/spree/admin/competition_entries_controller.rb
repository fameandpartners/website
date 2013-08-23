module Spree
  module Admin
    class CompetitionEntriesController < BaseController
      respond_to :html, :json

      def index
        @entries = CompetitionEntry.where(master: true).page(params[:page]).per(10)
      end

      def show
        @entry = CompetitionEntry.find(params[:id])
        @user = @entry.user
        @invited_users = 
        respond_with(@entry) do |format|
          format.js { render 'spree/admin/competition_entries/show' }
        end
      end

      private

      def model_class
        CompetitionEntry
      end
    end
  end
end
