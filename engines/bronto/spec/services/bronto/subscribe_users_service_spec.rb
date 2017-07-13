require 'rails_helper'

describe Bronto::SubscribeUsersService do
  describe '::perform' do
    let(:list_name) { 'list_name' }
    let(:client) { described_class.bronto_client }

    let(:users) do
      [
        { first_name: 'John', email: 'john@gmail.com' },
        { first_name: 'Doe', email: 'doe@gmail.com' }
      ]
    end

    it 'adds contacts to system and then to required list' do
      expect(client).to receive(:add_contacts).with(users)
      expect(client).to receive(:add_to_list).with(list_name: list_name,
                                                   emails: ['john@gmail.com', 'doe@gmail.com'])

      described_class.perform(list_name, users)
    end
  end

  describe '::bronto_client' do
    subject { described_class.bronto_client }

    it { is_expected.to be_a(Bronto::Client) }
  end
end
