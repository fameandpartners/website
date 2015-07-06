require 'spec_helper'

describe StyleQuiz::Tag, type: :model do

  context '#weight' do
    it 'returns weight for color' do
      expect(described_class.new(group: 'color').weight).to eq(described_class::WEIGHTS[:color])
    end

    it 'retures default weight' do
      expect(described_class.new(group: 'anygreatgroup').weight).to eq(described_class::WEIGHTS[:default])
    end
  end
end
