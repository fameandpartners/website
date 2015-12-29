require 'rails_helper'

RSpec.describe MoodboardComment, :type => :model do

  let(:current_user) { create(:spree_user) }
  let(:moodboard_item) { create(:moodboard_item) }
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
