require 'spec_helper'

describe ::StyleQuiz::AutomagicUserRegistrator, type: :model do
  let(:style_profile) { ::StyleQuiz::UserProfile.new }

  context "#create" do
    it "returns false for empty style profile" do
      service = StyleQuiz::AutomagicUserRegistrator.new(style_profile: style_profile)
      expect(service.create).to eq(nil)
    end

    it "returns false for owned profile" do
      style_profile.user = Spree::User.new
      service = StyleQuiz::AutomagicUserRegistrator.new(style_profile: style_profile)
      expect(service.create).to eq(nil)
    end
  end

  context "#build" do
    it "skips registration email" do
      user = StyleQuiz::AutomagicUserRegistrator.new(style_profile: style_profile).user
      expect(user.skip_welcome_email).to be true
    end

    it "marks user as automagically_registered" do
      user = StyleQuiz::AutomagicUserRegistrator.new(style_profile: style_profile).user
      expect(user.automagically_registered).to be true
    end

    it "copies data from style profile to user" do
      timestamp = 20.years.ago
      style_profile = StyleQuiz::UserProfile.new(
        fullname: 'Mary Smith',
        birthday: timestamp,
        email: 'mary.smith@example.com'
      )

      service = StyleQuiz::AutomagicUserRegistrator.new(style_profile: style_profile)
      user = service.create

      expect(user).not_to be_nil
      expect(user.first_name).to eq('Mary')
      expect(user.last_name).to eq('Smith')
      expect(user.birthday.to_date).to eq(timestamp.to_date)
    end
  end

end
