require 'spec_helper'

describe WeddingAtelier::EventDress do
  subject(:dress) { create(:wedding_atelier_event_dress) }
  let(:user) { create(:spree_user) }

  describe '#liked_by?' do
    context 'when the user likes the dress' do
      it 'returns true' do
        dress.like_by(user)
        expect(dress.liked_by?(user)).to be_truthy
      end
    end

    context 'when the user doesnt like the dress' do
      it 'returns false' do
        expect(dress.liked_by?(user)).to be_falsey
      end
    end
  end

  describe 'like_by' do
    it 'likes the dress by the given user' do
      expect{dress.like_by(user)}.to change{dress.reload.likes_count}.by(1)
    end
  end

  describe 'dislike_by' do
    it 'dislikes the dress by the given user' do
      dress.like_by(user)
      expect{dress.dislike_by(user)}.to change{dress.reload.likes_count}.by(-1)
    end
  end

end
