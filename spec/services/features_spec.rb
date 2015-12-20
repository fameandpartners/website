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
    stub_const("Features::DEFINED_FEATURES", %i(checkout_fb_login
                          content_revolution
                          delivery_date_messaging
                          enhanced_moodboards
                          fameweddings
                          maintenance
                          send_promotion_email_reminder
                          shipping_message
                          test_analytics
                          express_making
                          gift
                          google_tag_manager
                          marketing_modals
                          masterpass
                          moodboard
                          style_quiz
                          redirect_to_com_au_domain
                          sales
                          getitquick_unavailable
                          blah))
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

  describe 'active?' do
    it { expect { Features.active?('test_exist') }.to raise_error ArgumentError }
  end
end
