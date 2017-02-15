require 'rails_helper'

RSpec.describe Forms::WeddingPlanning, type: :form do
  subject(:form) { described_class.new(::WeddingPlanning.new) }

  describe 'validations' do
    subject(:errors) { form.errors.messages }

    describe 'first_name presence' do
      it do
        form.validate({})
        expect(errors).to include({ first_name: ["can't be blank"] })
      end
    end

    describe 'last_name presence' do
      it do
        form.validate({})
        expect(errors).to include({ last_name: ["can't be blank"] })
      end
    end

    describe 'email format' do
      context 'invalid format' do
        it do
          form.validate({ email: 'something@example.com' })
          expect(errors).not_to include(:email)
        end
      end

      context 'valid format' do
        it do
          form.validate({ email: 'invalid_email@formatlol' })
          expect(errors).to include({ email: ['is invalid'] })
        end
      end
    end

    describe 'wedding dates cannot be in the past' do
      context 'date in the past' do
        let(:past_date) { 2.days.ago.strftime('%m/%d/%Y') }

        it do
          form.validate({ wedding_date: past_date })
          expect(errors).to include({ wedding_date: ["Wedding date can't be in the past"] })
        end
      end

      context 'date in the future' do
        let(:future_date) { 2.days.from_now.strftime('%m/%d/%Y') }

        it do
          form.validate({ wedding_date: future_date })
          expect(errors).not_to include(:wedding_date)
        end
      end
    end
  end
end
