require 'rails_helper'

RSpec.describe MoodboardItemComment, :type => :model do

  let(:current_user) { create(:spree_user) }
  let(:moodboard_item) { create(:moodboard_item) }
  let(:valid_attributes) { {moodboard_item_id: moodboard_item.id,
                            user_id:           current_user.id,
                            comment:           'First test comment'} }

  context 'valid attributes' do
    it { expect(MoodboardItemComment.new(valid_attributes).moodboard_item_id).to be }
    it { expect(MoodboardItemComment.new(valid_attributes).user_id).to be }
    it { expect(MoodboardItemComment.new(valid_attributes).comment).to be }
    it { expect(MoodboardItemComment.new(valid_attributes).first_name).to be }
  end

  context 'invalid attributes' do
    it { expect(MoodboardItemComment.new).to have(1).error_on(:moodboard_item_id) }
    it { expect(MoodboardItemComment.new).to have(1).error_on(:user_id) }
    it { expect(MoodboardItemComment.new).to have(1).error_on(:comment) }
  end

end
