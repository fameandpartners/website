require 'spec_helper'

RSpec.describe ProductColorValue, type: :model do
  describe '#recommended' do
    let(:custom_color)      { build :product_color_value, custom: true }
    let(:recommended_color) { build :product_color_value, custom: false }

    it { expect(custom_color.recommended?).to be_falsey }
    it { expect(custom_color.custom?).to      be_truthy }
  end
end
