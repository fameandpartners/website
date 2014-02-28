module Spree
  module Admin
    class CompetitionEntriesController < BaseController
      respond_to :html, :json

      def index
        @entries = Competition::Entry.where(master: true).page(params[:page]).per(10)
      end

      def show
        @entry = Competition::Entry.find(params[:id])
        @user = @entry.user
        @invited_users = 
        respond_with(@entry) do |format|
          format.js { render 'spree/admin/competition_entries/show' }
        end
      end

      private

      def model_class
        Competition::Entry
      end
    end
  end
end
