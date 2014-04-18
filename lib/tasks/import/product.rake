require 'roo'

namespace :import do
  namespace :product do
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
        sku, price = book.row(index)
        sku = sku.dup.to_s.downcase.strip

        if sku.present? && price.present?
          master = Spree::Variant.where(deleted_at: nil, is_master: true).where('LOWER(TRIM(sku)) = ?', sku).order('id DESC').first
        end

        next unless master.present?

        master.price = price
        master.save!

        master.product.variants.each do |variant|
          variant.price = price
          variant.save!
        end
      end
    end
  end
end
