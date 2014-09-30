require 'csv'

module Spree
  module Admin
    class CompetitionParticipationsController < BaseController
      respond_to :csv

      def index
        @entries = CompetitionParticipation.includes(:spree_user).all
        send_data render_csv_to_string(@entries), filename: "competition-participations-#{Time.now.to_s(:number)}.csv", type: :csv
      end

      private

      def model_class
        CompetitionParticipation
      end

      def render_csv_to_string(entries)
        CSV.generate(col_sep: ';') do |csv|
          csv << ['Email',
                  'First Name',
                  'Last Name',
                  'Created At',
                  'Shares',
                  'Views']
          entries.each do |entry|
            csv << [entry.spree_user.email,
                    entry.spree_user.first_name,
                    entry.spree_user.last_name,
                    entry.created_at.to_s(:short),
                    entry.shares_count,
                    entry.views_count]
          end
        end
      end
    end
  end
end
