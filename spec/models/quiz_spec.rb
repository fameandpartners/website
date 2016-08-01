require 'spec_helper'

RSpec.describe Quiz, type: :model do
  describe 'scopes' do
    describe '.style_quiz' do
      let!(:style_quiz) { create(:quiz, :style) }

      it { expect(described_class.style_quiz).to eq(style_quiz) }
    end

    describe '.wedding_quiz' do
      let!(:wedding_quiz) { create(:quiz, :wedding) }

      it { expect(described_class.wedding_quiz).to eq(wedding_quiz) }
    end
  end
end
