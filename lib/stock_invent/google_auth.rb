require "google/api_client"

class StockInvent::GoogleAuth
  attr_reader :refresh_token, :client_id, :client_secret

  def initialize(options = {})
    @refresh_token    = options[:stock_invent_refresh_token]
    @client_id        = options[:stock_invent_provider_key]
    @client_secret    = options[:stock_invent_provider_secret]
  end

  def access_token
    @access_token ||= begin
      auth.fetch_access_token!
      auth.access_token
    end
  end

  def client
    @client ||= begin
      Google::APIClient.new(
        application_name: 'Fame&Partners spreadsheet reader',
        application_version: '0.0.1',
        auto_refresh_token: true
      )
    end
  end

  def auth
    @auth ||= begin
      auth = client.authorization
      auth.client_id      = client_id
      auth.client_secret  = client_secret
      auth.refresh_token  = refresh_token if refresh_token.present?
      auth.scope = "https://www.googleapis.com/auth/drive " + "https://spreadsheets.google.com/feeds/"
      auth
    end
  end
end
