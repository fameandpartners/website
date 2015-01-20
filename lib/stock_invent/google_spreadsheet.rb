require "google/api_client"
require "google_drive"

class StockInvent::GoogleSpreadsheet
  attr_reader :access_token, :file_url

  def initialize(options = {})
    @access_token    = options[:stock_invent_access_token]
    @file_url        = options[:stock_invent_file_url]
  end

  def status
    return :invalid if access_token.blank? || file_url.blank?

    binding.pry

    if session.present? && spreadsheet.present?
      return :valid
    else
      :invalid
    end

  rescue Exception => e
    :invalid
  end

  # returns object
  # product
  def details
  end

  private

    def session
      @session ||= GoogleDrive.login_with_oauth(access_token)
    end

    def spreadsheet
      @spreadsheet ||= session.spreadsheet_by_url(file_url)
    end

    def parse
    end
end
