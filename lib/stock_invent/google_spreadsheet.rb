require "google/api_client"
require "google_drive"

class StockInvent::GoogleSpreadsheet
  attr_reader :refresh_token, :file_url, :client_id, :client_secret

  def initialize(options = {})
    @access_token     = options[:stock_invent_access_token]
    @refresh_token    = options[:stock_invent_refresh_token]
    @file_url         = options[:stock_invent_file_url]
    @client_id        = options[:stock_invent_provider_key]
    @client_secret    = options[:stock_invent_provider_secret]
  end

  def status
    # no file set
    return :invalid if file_url.blank?

    # no access token, no ability to refresh it
    if access_token.blank? && (refresh_token.blank? || client_id.blank? || client_secret.blank?)
      return :invalid
    end

    raise details.inspect

    if session.present? && spreadsheet.present?
      return :valid
    else
      :invalid
    end

  #rescue Exception => e
  #  :invalid
  end

  #  OpenStruct.new(
  #    sku: '',
  #    colour: '',
  #    size: '',
  #    quantity: ''
  #  )
  def details
    result = []
    rows.each do |row_num|
      sku = worksheet[row_num, columns['sku']]
      colour = worksheet[row_num, columns['colour']]

      # dress can't be identified, so skip this
      next if sku.blank? || colour.blank?

      columns['sizes'].each do |size_name, column|
        quantity = worksheet[row_num, column]

        # quantity not specified - this doesn't mean what we have 0
        next if quantity.blank?

        result.push(OpenStruct.new({
          sku: sku,
          colour: colour,
          size: size_name,
          quantity: quantity.to_i
        }))
      end
    end

    result
  end

  private

    def access_token
      @access_token ||= exchange_refresh_token_to_access_token
    end

    def session
      @session ||= GoogleDrive.login_with_oauth(access_token)
    end

    def spreadsheet
      @spreadsheet ||= session.spreadsheet_by_url(file_url)
    end

    def worksheet
      @worksheet ||= begin
        spreadsheet.worksheets.find{|w| w.title == 'STOCK INVENTORY MANAGEMENT' } || spreadsheet.worksheets.first
      end
    end

    def exchange_refresh_token_to_access_token
      client.authorization.refresh_token = refresh_token

      auth = client.authorization
      auth.client_id      = client_id
      auth.client_secret  = client_secret
      auth.refresh_token  = refresh_token
      auth.scope = "https://www.googleapis.com/auth/drive " + "https://spreadsheets.google.com/feeds/"

      auth.fetch_access_token!

      auth.access_token
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

    def title_row_num
      @title_row_num ||= begin
        (1..worksheet.num_cols).find do |index|
          worksheet[index, 1].to_s.strip.downcase == 'sku' 
        end
      end
    end

    def columns
      @columns ||= begin
        result = { 'sku' => 1, 'sizes' => {} }

        (1..worksheet.num_cols).each do |index|
          title = (worksheet[title_row_num, index]).to_s.strip.downcase
          if title == 'colour'
            result['colour'] = index
          elsif title.match(/^\d{1,2}$/)
            result['sizes'][title] = index
          else
            # do nothing, this column don't needed
          end
        end

        result
      end
    end

    def rows
      @rows ||= Range.new(title_row_num.next, worksheet.num_rows)
    end
end
