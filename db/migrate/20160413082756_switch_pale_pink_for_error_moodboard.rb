class SwitchPalePinkForErrorMoodboard < ActiveRecord::Migration
  def up
    #migrate new duplicate dusty-pink to old dusty-pink
    MoodboardItem.where(color_id: 236).each do |mi|
      mi.color_id = 173
      mi.save!
    end
  end
end
