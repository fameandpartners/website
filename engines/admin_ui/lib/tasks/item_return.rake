namespace :item_return do
  task :recalculate => :environment do
    ItemReturn.all.each do |item_return|
      ItemReturnCalculator.new(item_return).run.save!
    end
  end

  desc 'migrate from return_requests'
  task :import_from_requests => :environment do
    ReturnRequestItem.find_each { |rri| rri.push_return_event }
  end

  desc 'import from spreadsheet, set FILE_PATH env var'
  task :import_from_returns_sheet => :environment do
    require 'returns/importer'

    # TODO - Remove hardcoded path
    # ENV['FILE_PATH'] ||= '/Users/garrow/fame/content/returns/140709_F&P_ReturnsCancellationsRefunds - Returns.csv'
    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?
    Returns::Importer.new(ENV['FILE_PATH']).import
  end

  desc 'import all, set FILE_PATH env var'
  task :import_all => [:import_from_requests, :import_from_returns_sheet]

  desc 'Backfill missing item_prices'
  task :backfill_item_prices => :environment do
    require 'ruby-progressbar'

    class BackfillItemPrices
      def call
        scope = ItemReturn.where('item_price is null')

        progressbar = ProgressBar.create(
        :total => scope.count,
        :format => '%a %e | ItemReturn %c/%C |%w%i|')

        scope.find_each do |item_return|
          progressbar.increment
          begin
            splitter = ItemPriceAdjustmentSplit.new(item_return.line_item)

            item_return.events.backfill_item_price.create!(
              item_price:          splitter.item_price_in_cents,
              item_price_adjusted: splitter.item_price_adjusted_in_cents
            )
          rescue StandardError => e
            $stderr.puts item_return.inspect
            $stderr.puts e.message
          end
        end
        progressbar.finish
      end
    end
    BackfillItemPrices.new.call
  end
end

