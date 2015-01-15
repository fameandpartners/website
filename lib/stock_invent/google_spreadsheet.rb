=begin
  load File.join(Rails.root, 'lib/stock_invent/google_spreadsheet.rb') 
  StockInvent::GoogleSpreadsheet.new().details
=end
=begin
  'https://console.developers.google.com/project/deft-scout-825/apiui/credential'
=end
require "rubygems"
require "google/api_client"
require "google_drive"


class StockInvent::GoogleSpreadsheet
  attr_reader :source, :client_id, :client_email

  def initialize
    @client_id = '761566927162-dbjpt2if542065lnjsmhvhgf5vcbfvuv.apps.googleusercontent.com'
    @client_secret = 'WNnu44bDCHMIPUhtE_maOHPa'
    @token = '"ya29.-wCQY5OrtLn4TON5bRD2VmsVWgUETpwOUdlskEtvjD6lL3t22ZUGObbOUJOHKkWb9UABbsptkgoM3Q"'
  end
=begin
  def initialize(spreadsheet = nil)
    @source = spreadsheet
    @source ||= 'https://docs.google.com/spreadsheets/d/1Rf4hAMR05Lpd8jl2mZsuL96CDi_j97VyaHop6j9oNtg/edit#gid=0'
  end
=end

  def details
    puts 'works'
    #get_access_token
    #parse
    get_access_token_for_service_account
    #check
  end

  def check
    path = File.join(Rails.root, 'lib/stock_invent/google_key.p12')
    passphrase = 'notasecret'
    client_email = '761566927162-uu9nnb7iq9kgofubrr0s2gp6qnog7ut2@developer.gserviceaccount.com'
    key = Google::APIClient::KeyUtils.load_from_pkcs12(path, passphrase)
    client = Google::APIClient.new({:application_name => "example-app", :application_version => "1.0"})

    client.authorization = Signet::OAuth2::Client.new(
      :person => 'name@example.com',
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :scope => 'https://www.googleapis.com/auth/drive.readonly',
      :issuer => client_email,
      :signing_key => key)

    client.authorization.fetch_access_token!

    drive = client.discovered_api('drive', 'v2')
    result = client.execute(api_method: drive.files.list)
  end


  def get_access_token_for_service_account
    path = File.join(Rails.root, 'lib/stock_invent/google_key.p12')
    passphrase = 'notasecret'
    rsa_private_key = Google::APIClient::PKCS12.load_key(path, passphrase)

    client_email = '761566927162-uu9nnb7iq9kgofubrr0s2gp6qnog7ut2@developer.gserviceaccount.com'
    asserter = Google::APIClient::JWTAsserter.new(
      client_email,
      scope,
      rsa_private_key
    )
    asserter.authorize()
    #client.authorization = asserter.authorize()
  end

  def get_access_token
    auth = client.authorization
    auth.client_id = @client_id
    auth.client_secret = @client_secret
    auth.scope = "https://www.googleapis.com/auth/drive " + "https://spreadsheets.google.com/feeds/"
    auth.redirect_uri = 'http://localhost:3600/oauth2callback'
    print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
    print("2. Enter the authorization code shown in the page: ")
    auth.code = $stdin.gets.chomp
    auth.fetch_access_token!
    access_token = auth.access_token
    puts access_token.inspect
  end

  def client
    @client ||= Google::APIClient.new(
      application_name: 'Fame&Partners spreadsheet reader',
      application_version: '0.0.1'
    )
  end

  def scope
    [
      "https://www.googleapis.com/auth/drive",
      "https://spreadsheets.google.com/feeds/"
    ]
  end
end

StockInvent::GoogleSpreadsheet.new().details

