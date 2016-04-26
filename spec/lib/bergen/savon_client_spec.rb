require 'spec_helper'

module Bergen
  RSpec.describe SavonClient do
    let(:client) { described_class.new }
    let(:production_wsdl) { Bergen::SavonClient::AVAILABLE_WSDLS['production'] }
    let(:staging_wsdl) { Bergen::SavonClient::AVAILABLE_WSDLS['staging'] }

    describe 'picks the right WSDL file for production/staging env' do
      context 'production env' do
        before(:each) { allow(Rails).to receive(:env).and_return('production') }

        it { expect(client.wsdl.document).to eq(production_wsdl) }
      end

      context 'any other env' do
        before(:each) { allow(Rails).to receive(:env).and_return('anything') }

        it { expect(client.wsdl.document).to eq(staging_wsdl) }
      end
    end

    describe '#auth_token', :vcr do
      it 'gets API auth token for further requests' do
        expect(client.auth_token).to eq('4jY2Ohy07m2G5DJAYEvHe33IYRKLkvJLAnQUhyglYZJdytUC8924iQ==')
      end
    end
  end
end
