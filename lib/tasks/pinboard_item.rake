namespace :pinboard_item do
  task :recalculate => :environment do
    PinboardItem.all.each do |pinboard_item| 
      PinboardItemCalculator.new(pinboard_item).run.save!
    end
  end
end

