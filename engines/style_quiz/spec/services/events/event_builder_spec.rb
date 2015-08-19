require 'spec_helper'

describe ::StyleQuiz::Events::EventBuilder, type: :model do
  let(:style_profile) { ::StyleQuiz::UserProfile.create }
  let(:timestamp) { Time.now }

  describe "#build" do
    it "process en-AU locale" do
      builder = described_class.new(style_profile: style_profile, site_version: double('sv', locale: 'en-AU'))
      event = builder.build({ date: timestamp.strftime("%d/%m/%Y")})
      expect(event.date).to eq(timestamp.to_date)
    end

    it "process en-US locale" do
      builder = described_class.new(style_profile: style_profile, site_version: double('sv', locale: 'en-US'))
      event = builder.build({ date: timestamp.strftime("%m/%d/%Y") })
      expect(event.date).to eq(timestamp.to_date)
    end
  end

  describe "#create" do
    it "raises error" do
      builder = described_class.new(style_profile: style_profile)
      expect { 
        builder.create({})
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "stores record" do
      builder = described_class.new(style_profile: style_profile)
      timestamp = 1.day.from_now
      event_args = { name: 'name', date: timestamp.strftime(I18n.t('date_format.backend'))}
      event = builder.create(event_args)

      expect(event.date).to eq(timestamp.to_date)
      expect(event.user_profile).to eq(style_profile)
    end
  end
end
