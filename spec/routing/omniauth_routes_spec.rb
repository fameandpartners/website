require 'spec_helper'

describe 'Omniauth routes', type: :routing do

  context "facebook callback" do
    it "with omitted site version" do 
      expect(:get => "/user/auth/facebook/callback").to route_to(
        "controller" => "spree/omniauth_callbacks",
        "action" => 'facebook'
      )
    end

    it "for 'us' version" do 
      expect(:get => "/us/user/auth/facebook/callback").to route_to(
        "controller" => "spree/omniauth_callbacks",
        "action" => 'facebook',
        "site_version" => 'us'
      )
    end

    it "for 'au' version" do 
      expect(:get => "/au/user/auth/facebook/callback").to route_to(
        "controller" => "spree/omniauth_callbacks",
        "action" => 'facebook',
        "site_version" => 'au'
      )
    end
  end
end
