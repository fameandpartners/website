require 'rails_helper'

RSpec.describe MoodboardComment, :type => :model do

  let(:moodboard_user) { create(:spree_user) }
  let(:current_user) { create(:spree_user) }
  let(:product) { create(:spree_product) }
  let(:moodboard) { Moodboard.create(user_id:     moodboard_user.id, name: 'Test Wedding',
                                     purpose:     'wedding', event_date: Date.today + 60.days,
                                     description: 'Test Wedding') }
  let(:moodboard_item) { MoodboardItem.create(moodboard_id: moodboard.id, product_id: product.id,
                                              uuid:         Random.new().rand(10000), product_color_value_id: 317,
                                              color_id:     38, user_id: moodboard_user.id) }
  let(:valid_attributes) { {moodboard_item_id: moodboard_item.id,
                            user_id:           current_user.id,
                            comment:           'First test comment'} }

  context 'valid attributes' do
    it { expect(MoodboardComment.new(valid_attributes).moodboard_item_id).to be }
    it { expect(MoodboardComment.new(valid_attributes).user_id).to be }
    it { expect(MoodboardComment.new(valid_attributes).comment).to be }
    it { expect(MoodboardComment.new(valid_attributes).first_name).to be }
  end

  context 'invalid attributes' do
    it { expect(MoodboardComment.create(valid_attributes.merge(moodboard_item_id: nil)).errors[:moodboard_item_id].size).to eq 1 }
    it { expect(MoodboardComment.create(valid_attributes.merge(user_id: nil)).errors[:user_id].size).to eq 1 }
    it { expect(MoodboardComment.create(valid_attributes.merge(comment: nil)).errors[:comment].size).to eq 1 }
  end

end
