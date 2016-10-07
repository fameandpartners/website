require 'rails_helper'

module Forms
  RSpec.describe StyleSession, type: :form do
    subject(:form) { described_class.new(::StyleSession.new) }

    describe 'validations' do
      it 'has default validations' do
        form.validate({})
        expect(form.errors.messages).to eq({
                                             full_name:    ["can't be blank"],
                                             session_type: ["can't be blank"]
                                           })
      end

      it 'validates email when required' do
        described_class::TYPES_REQUIRES_EMAIL.each do |session_type|
          form.validate({ session_type: session_type })
          expect(form.errors.messages).to include({ email: ['is invalid'] })
        end
      end

      it 'validates phone when required' do
        described_class::TYPES_REQUIRES_PHONE.each do |session_type|
          form.validate({ session_type: session_type })
          expect(form.errors.messages).to include({ phone: ["can't be blank"] })
        end
      end

      it 'validates timezone when required' do
        described_class::TYPES_REQUIRES_TIMEZONE.each do |session_type|
          form.validate({ session_type: session_type })
          expect(form.errors.messages).to include({ timezone: ["can't be blank"] })
        end
      end

      it 'validates preferred time when required' do
        described_class::TYPES_REQUIRES_PREFERRED_TIME.each do |session_type|
          form.validate({ session_type: session_type })
          expect(form.errors.messages).to include({ preferred_time: ["can't be blank"] })
        end
      end
    end
  end
end
