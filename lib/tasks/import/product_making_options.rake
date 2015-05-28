## 
# this task imports product making options from given file
# and places them to ProductMakingOption class.
# note: for now, only fast-making option available
# === Usage
#   bundle exec rake import:making_options:fast_delivery FILE_PATH=
#
require 'roo'

namespace :import do
  namespace :making_options do
    task :fast_delivery => :environment do
      book = load_data_file

      book.default_sheet = book.sheets.second # sheet Dataset1

      products_ids = []

      (book.first_row.next..book.last_row).each do |index|
        product_name  = book.cell(index, 1) # Daisy
        product_sku   = book.cell(index, 2) # "4b297-Size:4-Color:Burgundy"

        if product_name.present? && product_sku.present?
          products_ids.push(
            get_product_id(product_name, product_sku).try(:id)
          )
        end
      end

      products_ids = products_ids.compact.uniq
      Spree::Product.transaction do
        ProductMakingOption.fast_making.update_all(active: false)
        products = Spree::Product.includes(:making_options, :master).where(id: products_ids)
        products.each do |product|
          option = product.making_options.fast_making.first_or_initialize
          option.assign_default_attributes
          option.active = true
          option.save
        end
      end
    end
  end
end

##
# loads file by given FILE_PATH argument in cli
# raises exception for incorrect file format or empty argument
# returns Roo::Excel or Roo::Excelx instance

def load_data_file
  raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?

  file_path = ENV['FILE_PATH']

  if file_path =~ /\.xls$/
    book = Roo::Excel.new(file_path, false, :warning)
  elsif file_path =~ /\.xlsx$/
    book = Roo::Excelx.new(file_path, false, :warning)
  else
    raise 'Invalid file type'
  end
end

## 
# check database for product existence and return if we have such products
# accepts following attributes
#   name: Daisy
#   sku: "4b297-Size:4-Color:Burgundy"
def get_product_id(name, sku)
  name = name.downcase
  sku = sku.downcase
  variant = Spree::Variant.where('LOWER(TRIM(sku)) = ?', sku).first
  return variant.product if variant.present?

  product = Spree::Product.where('LOWER(TRIM(name)) = ?', name).first 
  return product if product.present?

  short_sku = sku.split('-').first.to_s
  variant = Spree::Variant.includes(:product).where("LOWER(TRIM(sku)) like '#{ short_sku }%'").first
  if variant && variant.product.name.match(/#{ name }/i)
    variant.product
  else
    nil
  end
end
