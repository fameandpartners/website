#require File.join(Rails.root, 'lib/stock_invent/google_spreadsheet.rb')
load File.join(Rails.root, 'lib/stock_invent/google_spreadsheet.rb')

module Spree
  module Admin
    class StockInventController < BaseController
      respond_to :html, :js, :json

      def edit
        @preferences = OpenStruct.new(preferences)
      end

      def update
        update_preferences(params[:preferences])

        respond_to do |format|
          format.js   do
            render nothing: true, status: :ok
          end

          format.html do
            redirect_to admin_stock_invent_path
          end
        end
      end

      def status
        access_token  = StockInvent::GoogleAuth.new(preferences).access_token
        stock_data    = StockInvent::GoogleSpreadsheet.new(
          access_token: access_token,
          file_url:     preferences['stock_invent_file_url']
        ).read

        @status = :valid
      rescue Exception => e
        @status = :invalid
      end

      def google_auth
        auth = StockInvent::GoogleAuth.new(preferences).auth
        auth.redirect_uri = admin_stock_invent_google_auth_callback_url

        # approval_prompt: auto   # default
        # approval_prompt: force  # to receive refresh token each time
        redirect_to auth.authorization_uri(approval_prompt: 'force').to_s
      end

      def auth_callback
        auth = StockInvent::GoogleAuth.new(preferences).auth
        # for case with non-refreshing token this required
        auth.redirect_uri = admin_stock_invent_google_auth_callback_url
        auth.code = params[:code]

        auth.fetch_access_token!

        update_preferences(stock_invent_refresh_token: auth.refresh_token)

        # update token
        redirect_to admin_stock_invent_path, notice: 'permissions tokens has been successfully updated'
      end

      private

        def model_class
          Spree::Preference
        end

        def preferences_keys
          [
            "stock_invent_provider_key",
            "stock_invent_provider_secret",
            "stock_invent_refresh_token",
            "stock_invent_file_url"
          ]
        end

        def preferences
          @_preferences ||= Repositories::SpreePreference.read_all(preferences_keys)
        end

        def update_preferences(values)
          @_preferences = nil
          values.keys.each do |key|
            if preferences_keys.include?(key.to_s)
              Repositories::SpreePreference.update(key, values[key])
            end
          end
        end
    end
  end
end
