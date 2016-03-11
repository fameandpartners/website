require 'rails_helper'

module Marketing
  describe BodyCalculatorMeasure, type: :model do
    describe 'model validations' do
      context 'email validation' do
        it { is_expected.to allow_value('email@example.com').for(:email) }
        it { is_expected.not_to allow_value('invalid@email').for(:email) }
      end

      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_presence_of(:shape) }
      it { is_expected.to validate_presence_of(:bust_circumference) }
      it { is_expected.to validate_presence_of(:under_bust_circumference) }
      it { is_expected.to validate_presence_of(:waist_circumference) }
      it { is_expected.to validate_presence_of(:hip_circumference) }
    end
  end
end
