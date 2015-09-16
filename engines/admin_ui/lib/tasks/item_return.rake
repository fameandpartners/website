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

  desc 'import from spreadsheet'
  task :import_from_returns_sheet => :environment do
    require 'returns/importer'

    # TODO - Remove hardcoded path
    # ENV['FILE_PATH'] ||= '/Users/garrow/fame/content/returns/140709_F&P_ReturnsCancellationsRefunds - Returns.csv'
    raise 'FILE_PATH required' if ENV['FILE_PATH'].blank?
    Returns::Importer.new(ENV['FILE_PATH']).import
  end
end

