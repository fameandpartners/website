#require File.join(Rails.root, 'lib/stock_invent/google_spreadsheet.rb')
load File.join(Rails.root, 'lib/stock_invent/google_spreadsheet.rb')

module Spree
  module Admin
    class StockInventController < BaseController
      respond_to :html, :js, :json

      def edit
        @preferences = OpenStruct.new(get_preferences)
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

      # remote
      def status
        @status = StockInvent::GoogleSpreadsheet.new(
          stock_invent_access_token:  get_preference(:stock_invent_access_token),
          stock_invent_file_url:      get_preference(:stock_invent_file_url)
        ).status
      end

      # admin_stock_invent_access_token_request_path
      def google_auth
        # approval_prompt: auto   # default
        # approval_prompt: force  # to receive refresh token
        redirect_to auth.authorization_uri(approval_prompt: 'auto').to_s
      end

      def auth_callback
        auth.code = params[:code]

        auth.fetch_access_token!

        update_preference('stock_invent_access_token',  auth.access_token)
        update_preference('stock_invent_refresh_token', auth.refresh_token)

        # update token
        redirect_to admin_stock_invent_path, notice: 'access token has been successfully updated'
      end

      private

        def model_class
          Spree::Preference
        end

        def client
          @client ||= begin
            client ||= Google::APIClient.new(
              application_name: 'Fame&Partners spreadsheet reader',
              application_version: '0.0.1',
              auto_refresh_token: true
            )
          end
        end

        def auth
          @auth ||= begin
            auth = client.authorization
            auth.client_id = client_id
            auth.client_secret = client_secret
            auth.scope = "https://www.googleapis.com/auth/drive " + "https://spreadsheets.google.com/feeds/"
            auth.redirect_uri = admin_stock_invent_google_auth_callback_url
            auth
          end
        end

        def preferences_keys
          [
            "stock_invent_provider_key",
            "stock_invent_provider_secret",
            "stock_invent_access_token",
            "stock_invent_refresh_token",
            "stock_invent_file_url"
          ]
        end

        def update_preferences(values)
          preferences_keys.map do |key|
            value = values[key]
            update_preference(key, value)
            value
          end
        end

        def update_preference(key, value)
          preference = Spree::Preference.where(key: key).first_or_initialize
          preference.value_type ||= 'string'
          preference.value = value
          preference.save
        end

        def get_preferences
          {}.tap do |preferences|
            preferences_keys.each do |key|
              preferences[key.to_sym] = get_preference(key)
            end
          end
        end

        def get_preference(key)
          Spree::Preference.where(key: key.to_s).first.try(:value) || ''
        end

        def client_id
          #return '761566927162-dbjpt2if542065lnjsmhvhgf5vcbfvuv.apps.googleusercontent.com'
          @client_id ||= get_preference('stock_invent_provider_key')
        end

        def client_secret
          #return 'WNnu44bDCHMIPUhtE_maOHPa'
          @client_secret ||= get_preference('stock_invent_provider_secret')
        end
    end
  end
end
