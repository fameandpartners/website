# require 'spec_helper'

require 'rack'
require 'rails'
require 'rspec-rails'
require_relative '../../app/helpers/marketing_helper'

RSpec.describe MarketingHelper, :type => :helper do

  let(:helper) { Object.new.class.send(:include, MarketingHelper) }

  before do
    allow(helper).to receive('params').and_return({})
  end

  describe '#decode' do
    context 'given a base64 string containing spaces' do
      let(:original_input)    { '<h4><i></h4>' }
      let(:encoded_value)     { 'PGg0PjxpPjwvaDQ+' }
      let(:as_url_param)      { "v=#{encoded_value}" }
      let(:param_with_spaces) { 'PGg0PjxpPjwvaDQ ' }

      let(:parsed_param_with_spaces) {
        Rack::Utils.parse_query("v=#{ Base64.strict_encode64(original_input) }")["v"]
      }

      describe 'decoding' do
        it 'decodes spaces as if given pluses (+)' do
          expect(helper.decode(param_with_spaces)).to        eq original_input
          expect(helper.decode(parsed_param_with_spaces)).to eq original_input
        end
      end

      context 'raw mode' do
        before do
          allow(helper).to receive('params').and_return({raw: true})
        end

        it 'passes the raw value' do
          raw_value     = double('foo')
          decoded_value = helper.decode(raw_value)

          expect(decoded_value).to eql raw_value
        end
      end

      describe 'valid test data' do
        it 'input generates a plus (+)' do
          expect(
            Base64.strict_encode64(original_input)
          ).to eq encoded_value
        end

        it 'parsing converts plus (+) to space' do
          expect(
            Rack::Utils.parse_query(as_url_param)
          ).to eq({ "v" => parsed_param_with_spaces })
        end
      end
    end
  end
end
