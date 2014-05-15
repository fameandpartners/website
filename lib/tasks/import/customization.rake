require 'roo'

namespace :import do
  namespace :customization do
    task :prices => :environment do
      raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?

      file_path = ENV['FILE_PATH']

      if file_path =~ /\.xls$/
        book = Roo::Excel.new(file_path, false, :warning)
      elsif file_path =~ /\.xlsx$/
        book = Roo::Excelx.new(file_path, false, :warning)
      else
        raise 'Invalid file type'
      end

      book.default_sheet = book.sheets.first

      (book.first_row..book.last_row).each do |index|
        sku = book.cell(index, 1)
        sku = sku.to_s.dup.downcase.strip

        customizations = [
          {
            position: 1,
            presentation: book.cell(index, 5).to_s.strip,
            price: book.cell(index, 6).to_f
          }, {
            position: 2,
            presentation: book.cell(index, 7).to_s.strip,
            price: book.cell(index, 8).to_f
          }, {
            position: 3,
            presentation: book.cell(index, 9).to_s.strip,
            price: book.cell(index, 10).to_f
          }
        ]

        next if customizations.all?{ |c| c[:price].blank? || c[:price].zero? }

        puts %Q(Search product by SKU "#{sku}")

        masters = Spree::Variant.where(deleted_at: nil, is_master: true).where('LOWER(TRIM(sku)) = ?', sku)

        if masters.blank?
          puts %q(  Products not found)
          next
        end

        puts %Q(  #{ masters.count } #{ 'product'.pluralize(masters.count) } found)

        masters.each do |master|
          product = master.product

          puts %Q(    Processing product with ID: "#{product.id}")

          customizations.each do |customization|
            next if customization[:price].blank? || customization[:price].zero?

            customisation_value = product.customisation_values.where(position: customization[:position]).first

            if customisation_value.blank?
              puts %Q(      Customization with POSITION: "#{customization[:position]}" not found, but should exists with NAME "#{ customization[:presentation].downcase }")
              next
            else
              puts %Q(      Processing customization with POSITION: "#{ customization[:position] }")
            end

            if customisation_value.presentation.strip.downcase.eql?(customization[:presentation].downcase)
              puts %Q(        Customization NAME is VALID)
            else
              puts %Q(        Customization NAME is INVALID, in SPREADSHEET "#{ customization[:presentation].downcase }" and in DATABASE "#{ customisation_value.presentation.strip.downcase }")
            end

            if customisation_value.update_attributes(price: customization[:price])
              puts %Q(        Customization PRICE set to #{ customization[:price] })
            end
          end
        end
      end
    end
  end
end