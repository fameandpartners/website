require 'spec_helper'
require_relative '../../app/models/feature_flag'

RSpec.describe FeatureFlag, type: :model do

  before(:each) do
    #Store the current state of the Feature Flags.  This will keep the users
    #dev environment intact as there is no "dev" Redis.
    @feat_store = []
    Features.features.each do |feature|
      @feat_store << { feature: feature, active: Features.active?(feature)}
    end
  end

  context 'validations' do

    describe 'returns not valid' do
      it 'has a null flag' do
        feature_flag = FeatureFlag.new(flag: nil, enabled: 'true')
        expect(feature_flag.valid?).to be_falsey
      end

      it 'has a flag that already exists' do
        feature_flag = FeatureFlag.new(flag: 'enhanced_moodboards', enabled: 'true')
        expect(feature_flag.valid?).to be_falsey
      end
    end

    describe 'returns valid' do
      it 'has a non-null flag' do
        feature_flag = FeatureFlag.new(flag: 'test_flag', enabled: 'true')
        expect(feature_flag.valid?).to be_truthy
      end
    end

  end

  context '#save' do
    it 'has a flag created that is enabled' do
      feature_flag = FeatureFlag.new(flag: 'test_flag', enabled: 'true')
      feature_flag.save
      expect(Features.active?(feature_flag.flag)).to be_truthy
    end
    it 'has a flag created that is disabled' do
      feature_flag = FeatureFlag.new(flag: 'test_flag', enabled: 'false')
      feature_flag.save
      expect(Features.active?(feature_flag.flag)).to be_falsey
    end
  end

  context '#state_string' do
    it 'returns Enabled' do
      feature_flag = FeatureFlag.new(flag: 'test_flag', enabled: 'true')
      expect(feature_flag.state_string).to eq 'Enabled'
    end
    it 'returns Disabled' do
      feature_flag = FeatureFlag.new(flag: 'test_flag', enabled: 'false')
      expect(feature_flag.state_string).to eq 'Disabled'
    end
  end

  after(:each) do
    #Restore the state of the Feature Flags before the test was run
    Features.clear!
    @feat_store.each do |feature|
      feature[:active] == 'true' ? Features.activate(feature[:feature]) : Features.deactivate(feature[:feature])
    end
  end

end
