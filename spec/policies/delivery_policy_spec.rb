require 'spec_helper'

describe Policies::DeliveryPolicy, type: :policy do
  let(:host_class) do
    Class.new do
      include Policies::DeliveryPolicy
    end
  end

  subject { host_class.new }

  describe '#major_value_from_period' do
    it 'returns latest value from period' do
      expect(subject.send(:major_value_from_period, '7 - 10 business days')).to eq(10)
    end

    it 'returns value even if it is single' do
      expect(subject.send(:major_value_from_period, '4 weeks')).to eq(4)
      expect(subject.send(:major_value_from_period, '43 minutes')).to eq(43)
    end
  end
end
