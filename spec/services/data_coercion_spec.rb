require 'spec_helper'

describe DataCoercion do
  it { expect(DataCoercion.string_to_boolean("yes")).to eq true  }
  it { expect(DataCoercion.string_to_boolean("no")).to  eq false }

  describe 'allows fallback for values that Coercible fails' do
    it 'defaults to false' do
      expect(DataCoercion.string_to_boolean "whatever" ).to eq false
    end

    describe 'default value' do
      it 'uses provided' do
        expect(DataCoercion.string_to_boolean "whatever", default: true ).to eq true
      end

      describe 'is also coerced' do
        it { expect(DataCoercion.string_to_boolean "whatever", default: 1).to   eq true }
        it { expect(DataCoercion.string_to_boolean "whatever", default: nil).to eq false }
      end
    end
  end
end

