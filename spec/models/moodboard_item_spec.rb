require 'rails_helper'

RSpec.describe MoodboardItem, :type => :model do

  describe 'liking' do

    def moodboard_item_attributes
      {
        moodboard_id:           rand(10_000),
        product_id:             rand(10_000),
        product_color_value_id: rand(10_000),
        color_id:               rand(10_000),
        user_id:                rand(10_000),
        variant_id:             rand(10_000)
      }
    end

    it 'initially has no likes' do
      moodboard_item = MoodboardItemEvent.creation.create!(moodboard_item_attributes).moodboard_item

      expect(moodboard_item.user_likes).to eq("")
      expect(moodboard_item.likes).to eq(0)
    end

    it 'number of likes increases' do
      moodboard_item = MoodboardItemEvent.creation.create!(moodboard_item_attributes).moodboard_item

      moodboard_item.events.like.create(user_id: 555)
      moodboard_item.events.like.create(user_id: 777)

      moodboard_item.reload

      expect(moodboard_item.user_likes).to eq("555,777")
      expect(moodboard_item.likes).to eq(2)
    end

    it 'but only count one like per user' do
      moodboard_item = MoodboardItemEvent.creation.create!(moodboard_item_attributes).moodboard_item

      moodboard_item.events.like.create(user_id: 555)
      moodboard_item.events.like.create(user_id: 555)
      moodboard_item.events.like.create(user_id: 777)
      moodboard_item.events.like.create(user_id: 777)

      moodboard_item.reload

      expect(moodboard_item.user_likes).to eq("555,777")
      expect(moodboard_item.likes).to eq(2)
    end
  end
end
