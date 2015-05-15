require 'spec_helper'

describe 'Devise routes', type: :routing do

  context "edit spree user password url" do
    it "recognizes as passwords/edit" do
      path = Rails.application.routes.url_helpers.edit_spree_user_password_path

      expect(get: path).to route_to(
        "controller" => "spree/user_passwords",
        "action" => 'edit'
      )
    end
  end
end
