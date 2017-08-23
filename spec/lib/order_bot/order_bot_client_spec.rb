require 'spec_helper'
require 'pry-byebug'

module OrderBot
   describe OrderBotClient do
  
    let(:client) {OrderBot::OrderBotClient.new('apitestfp@test.com', 'Testing2000')}
    describe 'get measurement type' do
      it 'for non-existant measurement' do        
        expect(client.get_measurement_type_id_by_name('country')).to be_falsey
      end
      it 'for existing measurement' do        
        expect(client.get_measurement_type_id_by_name('Piece')).to eq 3297
      end

    end
  end
end
