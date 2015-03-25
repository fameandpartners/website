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
    #allow(Features).to receive(:kv_store).and_return(kv_store)
    allow(Features).to receive(:rollout).and_return(Rollout.new(kv_store))
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
end
