require 'rails_helper'

describe Bronto::SubscribeUsersWorker do
  describe '#perform' do
    it 'delegates #perform to Bronto::SubscribeUsersService' do
      list_name = double(:name)
      users = double(:users)

      expect(Bronto::SubscribeUsersService).to receive(:perform).with(list_name, users)
      subject.perform(list_name, users)
    end
  end
end
