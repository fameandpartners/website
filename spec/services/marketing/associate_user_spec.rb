require 'spec_helper'

describe Marketing::UserVisits do
  let(:utm_params) { 
    {
      utm_campaign:   'utm_campaign',
      utm_source:     'utm_source',
      utm_medium:     'utm_medium',
      utm_term:       'utm_term',
      utm_content:    'utm_content'
    }
  }
  let(:user) { create(:spree_user) }

  context "associate_with_user_by_token" do
    it "update ownership and resets token" do
      service = Marketing::CaptureUtmParams.new(nil, nil, utm_params)
      result = service.record_visit!

      expect(
        Marketing::UserVisits.associate_with_user_by_token(
          user: user, token: service.user_token
        )
      ).to be true

      result = Marketing::UserVisit.find(result.id)

      expect(result.user_token).to be_nil
      expect(result.spree_user_id).to eq(user.id)
    end

    it "merge previous records" do
      Marketing::CaptureUtmParams.new(user, nil, utm_params).record_visit!
      result = Marketing::CaptureUtmParams.new(nil, nil, utm_params).record_visit!

      expect(
        Marketing::UserVisits.associate_with_user_by_token(
          user: user, token: result.user_token
        )
      ).to be true

      record = Marketing::UserVisit.first
      expect(record.visits).to eq(2)

      expect(Marketing::UserVisit.count).to eq(1)
    end
  end
end
