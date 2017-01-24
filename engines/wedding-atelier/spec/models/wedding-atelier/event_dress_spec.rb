require 'spec_helper'

describe WeddingAtelier::EventDress do
  subject(:dress) { create(:wedding_atelier_event_dress, fit: nil, style: nil) }
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

    context 'given a nil user' do
      let(:user) { nil }

      it do
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

  describe '#images' do
    let(:custom_dress) do
      create(
        :wedding_atelier_event_dress,
        product: create(:spree_product, sku: '1234'),
        fabric: create(:customisation_value, name: 'HG'),
        color:   create(:option_value, name: 'black'),
        size: create(:option_value, name: 'S'),
        style: create(:customisation_value, presentation: 'style', position: 0, name: 'S5'),
        fit: create(:customisation_value, presentation: 'fit', position: 1, name: 'F4'),
        length: create(:customisation_value, name: 'AK'),
        height: 'petite')
    end

    it 'returns the file names of images related to this dress' do
      images = custom_dress.images
      expect(images[:front][:thumbnail][:white]).to match /^.*\/180x260\/white\/1234-HG-BLACK-S5-F4-AK-FRONT.jpg$/
      expect(images[:front][:thumbnail][:grey]).to match /^.*\/180x260\/grey\/1234-HG-BLACK-S5-F4-AK-FRONT.jpg$/
      expect(images[:front][:moodboard]).to match /^.*\/280x404\/1234-HG-BLACK-S5-F4-AK-FRONT.jpg$/
      expect(images[:front][:normal]).to match /^.*\/900x1300\/1234-HG-BLACK-S5-F4-AK-FRONT.jpg$/
      expect(images[:front][:large]).to match /^.*\/1800x2600\/1234-HG-BLACK-S5-F4-AK-FRONT.jpg$/
      expect(images[:back][:thumbnail][:white]).to match /^.*\/180x260\/white\/1234-HG-BLACK-S5-F4-AK-BACK.jpg$/
      expect(images[:back][:thumbnail][:grey]).to match /^.*\/180x260\/grey\/1234-HG-BLACK-S5-F4-AK-BACK.jpg$/
      expect(images[:back][:moodboard]).to match /^.*\/280x404\/1234-HG-BLACK-S5-F4-AK-BACK.jpg$/
      expect(images[:back][:normal]).to match /^.*\/900x1300\/1234-HG-BLACK-S5-F4-AK-BACK.jpg$/
      expect(images[:back][:large]).to match /^.*\/1800x2600\/1234-HG-BLACK-S5-F4-AK-BACK.jpg$/
      expect(images[:real][:thumbnails][0]).to match /^.*\/350x500\/1234-HG-BLACK-S0-F0-AK-FRONT.jpg$/
      expect(images[:real][:large][0]).to match /^.*\/1440x1310\/1234-HG-BLACK-S0-F0-AK-FRONT.jpg$/
    end
  end

end
