namespace :moodboard_item do
  task :recalculate => :environment do
    MoodboardItem.all.each do |moodboard_item|
      MoodboardItemCalculator.new(moodboard_item).run.save!
    end
  end
end

