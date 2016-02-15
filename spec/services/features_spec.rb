require 'spec_helper'

describe Features do
  class KV
    attr_reader :kv
    def initialize
      @kv = {}
    end

    def set(key,value)
      kv[key] = value
    end

    def get(key)
      kv[key]
    end
  end

  let(:kv_store) { KV.new }

  before do
    allow(Features).to receive(:kv_store).and_return(kv_store)
  end

  describe 'activation' do
    it 'activates' do
      Features.activate(:blah)
      expect(Features.active?(:blah)).to be true
    end
    it 'deactivates' do
      Features.activate(:blah)
      expect(Features.active?(:blah)).to be true

      Features.deactivate(:blah)
      expect(Features.active?(:blah)).to be false
    end
  end

  describe '.description' do
    it do
      expect(Features.description(:undefined_feature_name)).to eq "Undocumented"
    end

    it do
      expect(Features.description(:maintenance)).to eq "Maintennance Mode - Puts site offline"
    end
  end
end
