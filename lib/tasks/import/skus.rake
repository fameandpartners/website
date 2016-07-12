require 'ruby-progressbar'

namespace :import do
  desc 'Generate All SKUS'
  task :skus => :environment do

    require 'ruby-progressbar'
    def format_bar(name)
      "%a %e | #{name} %c/%C |%w%i|"
    end

    progressbar = ProgressBar.create(:total => Spree::Variant.count + Spree::LineItem.count)

    progressbar.format = format_bar('Variants')
    Spree::Product.unscoped do
      Spree::Variant.find_each do |variant|
        progressbar.increment

        begin
          GlobalSku.find_or_create_by_spree_variant(variant: variant)
        rescue StandardError => e
          puts e.message
          next
        end
      end
    end


    progressbar.format = format_bar('LineItems')
    Spree::Variant.unscoped do
      Spree::LineItem.find_each do |li|
        progressbar.increment
        next unless li.order.present?

        begin
          lip   = Orders::LineItemPresenter.new(li, Orders::OrderPresenter.new(li.order))

          # Some very old orders are missing variants.
          next unless lip.item.variant.present?

          # Skip incomplete orders
          next unless lip.order.order.complete?

          GlobalSku.find_or_create_by_line_item(line_item_presenter: lip)

        rescue StandardError => e
          puts e.message
          next
        end
      end
    end
    progressbar.finish
  end
end
