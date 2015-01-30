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

  context "asssociate_with_user_by_token" do
    it "update ownership and resets token" do
      service = Marketing::CaptureUtmParams.new(nil, nil, utm_params)
      result = service.record_visit!

      expect(
        Marketing::UserVisits.asssociate_with_user_by_token(
          user: user, token: service.user_token
        )
      ).to be true

      result = Marketing::UserVisit.find(result.id)

      expect(result.user_token).to be_nil
      expect(result.spree_user_id).to eq(user.id)
    end
  end
end
