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
end

