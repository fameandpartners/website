require 'spec_helper'

describe Marketing::CaptureUtmParams do
  let(:utm_params) { 
    {
      utm_campaign:   'utm_campaign',
      utm_source:     'utm_source',
      utm_medium:     'utm_medium',
      utm_term:       'utm_term',
      utm_content:    'utm_content'
    }
  }

  context "base" do
    let(:subject) { Marketing::CaptureUtmParams.new(nil, nil, utm_params) }

    it "store campaign visit" do
      result = subject.record_visit!

      expect(result).not_to be_nil
      expect(result.utm_campaign).to eq(utm_params[:utm_campaign])
    end

    it "increases visits num for returning visit" do
      subject.record_visit!

      service = Marketing::CaptureUtmParams.new(nil, subject.user_token, utm_params)
      result = service.record_visit!

      expect(result.visits).to eq(2)
    end

    it "adding another campaign visit" do
      result = subject.record_visit!

      service = Marketing::CaptureUtmParams.new(
        nil, subject.user_token, utm_params.merge(utm_campaign: 'another_utm_campaign')
      )
      service.record_visit!

      expect(Marketing::UserVisit.where(user_token: subject.user_token).count).to eq(2)
    end
  end

  context "for logged user" do
    let(:user) { create(:spree_user) }
    let(:subject) { Marketing::CaptureUtmParams.new(user, nil, utm_params)  }

    it "creates records associated with user" do
      service = Marketing::CaptureUtmParams.new(:user, nil, utm_params) 
    end

    it "don't create token" do
      subject.record_visit!
      expect(subject.user_token_created?).to be false
    end
  end

  context "for guest user" do
    it "generates new token" do
      service = Marketing::CaptureUtmParams.new(nil, nil, utm_params) 
      result = service.record_visit!

      expect(service.user_token_created?).to be true
      expect(service.user_token).to eq(result.user_token)
      expect(result.user_token).not_to be_empty
    end

    it "creates records for given token" do
      token =  'my test token'
      service = Marketing::CaptureUtmParams.new(nil, token, utm_params) 
      result = service.record_visit!

      expect(Marketing::UserVisit.where(user_token: token).count).to eq(1)
    end
  end
end
