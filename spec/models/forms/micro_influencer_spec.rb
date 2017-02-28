require 'rails_helper'

RSpec.describe Forms::MicroInfluencer, type: :form do
  subject(:form) { described_class.new(::MicroInfluencer.new) }

  describe 'validations' do
    subject(:errors) { form.errors.messages }

    describe 'name presence' do
      it do
        form.validate({})
        expect(errors).to include({ name: ["can't be blank"] })
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

  end
end
