require 'spec_helper'

describe StyleQuiz::UserProfile, :type => :model do
  let(:subject) { StyleQuiz::UserProfile.new }

  context '#user_styles' do
    it 'exists' do
      expect(subject.user_styles).to be_blank
    end

    it 'have rates' do
      subject.user_styles.each do |user_style|
        expect(user_style.rate).not_to be_nil
      end
    end
  end

  context '#primary_style' do
    it 'exists' do
      expect(subject.primary_user_style).not_to be_nil
    end
  end
end
