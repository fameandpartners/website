require 'spec_helper'

describe StyleQuiz::UserStyleProfiles::UserAnswersUpdater, type: :model do
  let(:style_profile) { ::StyleQuiz::UserProfile.create }
  let(:site_version)  { double('sv', locale: 'en-AU') }
  let(:service) { described_class.new(style_profile: style_profile, site_version: site_version) }
  let(:date_sample) { 1.day.from_now.strftime(service.date_format) }

  context "#apply" do
    it "will update_profile" do
      event = double('event')
      answers = { events: { 0 => event }}
      expect(service).to receive(:update_profile).with(answers)
      expect(service).to receive(:update_events).with([event])
      expect(service).to receive(:mark_as_completed)

      expect(service.apply(answers)).to be true
    end
  end

  context "#update_profile" do
    let(:answers) { { fullname: 'Mary.smith', email: 'mary.smit@e.com', birthday: date_sample, ids: [1,2,3] }}

    it "update full name" do
      service.send(:update_profile, answers)
      expect(style_profile.fullname).to eq(answers[:fullname])
    end

    it "updates email" do
      service.send(:update_profile, answers)
      expect(style_profile.email).to eq(answers[:email])
    end

    it "update answer ids" do
      service.send(:update_profile, answers)
      expect(style_profile.answer_ids).to eq(answers[:ids])
    end

    it "updates tags" do
      service.send(:update_profile, answers)
      expect(style_profile.tags).to be_blank
    end
  end

  context "#update_events" do
    it "add new events" do
      service.send(:update_events, [name: 'name', date: date_sample])
      expect(style_profile.events.count).to eq(1)
    end

    it "replaces existing events with new ones" do
      service.send(:update_events, [name: 'name', date: date_sample])
      service.send(:update_events, [name: 'new_event_name', date: date_sample])

      expect(style_profile.events.count).to eq(1)
      expect(style_profile.events.first.name).to eq( 'new_event_name')
    end

    it "don't create invalid events" do
      service.send(:update_events, [name: 'name', date: Time.now.to_s(:db)])
      expect(style_profile.events.count).to eq(0)
    end

    it "clear events" do
      service.send(:update_events, [name: 'name', date: date_sample])
      service.send(:update_events, [])
      expect(style_profile.events.count).to eq(0)
    end
  end

  context "#mark_as_completed" do
    it "will set completed at" do
      service.send(:mark_as_completed)
      expect(style_profile.completed?).to be true
    end

    it "will not change already completed date" do
      style_profile.update_column(:completed_at, 1.day.ago)

      expect {
        service.send(:mark_as_completed)
      }.not_to change(style_profile, :completed_at)
    end
  end
end
