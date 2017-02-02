require 'spec_helper'
require 'rake'
load File.expand_path("../../../../lib/tasks/wedding-atelier_tasks.rake", __FILE__)

describe WeddingAtelier::CustomizationsController, type: :controller do
  routes { WeddingAtelier::Engine.routes }
  let(:user) { create(:spree_user, first_name: 'foo', last_name: 'bar') }
  let(:event) { create(:wedding_atelier_event) }
  before do
    event.assistants << user
    ot = create(:option_type, name: 'dress-size')
    ot.option_values << create(:option_value, name: 'US0/AU4')
    Rake::Task.define_task(:environment)
    Rake::Task['wedding_atelier:populate_products'].invoke
    custom_sign_in user
    user.add_role('bridesmaid', event)
  end

  describe 'GET#index' do
    it 'gets all resources needed for a customization' do
      get :index, { event_id: event.id }

      customization = JSON.parse(response.body)["customization"]
      expect(customization["silhouettes"]).not_to be_empty
      expect(customization["colors"]).not_to be_empty
      expect(customization["sizes"]).not_to be_empty
      expect(customization["heights"]).not_to be_empty
      expect(customization["assistants"]).not_to be_empty
      expect(customization["silhouettes"][0]["fits"]).not_to be_empty
      expect(customization["silhouettes"][0]["styles"]).not_to be_empty
    end
  end
end
