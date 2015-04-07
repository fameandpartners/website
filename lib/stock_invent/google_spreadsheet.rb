require "google/api_client"
require "google_drive"

class StockInvent::GoogleSpreadsheet
  attr_reader :access_token, :file_url

  def initialize(options = {})
    @access_token = options[:access_token]
    @file_url     = options[:file_url]
  end

  def read
    @parsed_details ||= parse_details
  end

  private

    def parse_details
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

          result.push(FastOpenStruct.new({
            sku: sku,
            colour: colour,
            size: size_name,
            quantity: quantity.to_i
          }))
        end
      end

      result
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
