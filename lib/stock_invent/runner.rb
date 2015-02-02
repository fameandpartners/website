class StockInvent::Runner
  def self.run
    if Repositories::SpreePreference.read('stock_invent_enabled')
      load_from_google_spreadsheet
    else
      puts "-- skipped disabled stock invent run"
    end
  end

  def self.load_from_google_spreadsheet
    # google spreadsheet
    options = Repositories::SpreePreference.read_all(
      'stock_invent_refresh_token', 
      'stock_invent_provider_key', 
      'stock_invent_provider_secret'
    )
    access_token  = StockInvent::GoogleAuth.new(options).access_token

    stock_data    = StockInvent::GoogleSpreadsheet.new(
      access_token: access_token,
      file_url: Repositories::SpreePreference.read('stock_invent_file_url')
    ).read

    UpdateStockQuantites.new(stock_data).process
  end
end
