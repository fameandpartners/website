require 'spec_helper'

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

     describe 'post product' do
      it 'create new product' do        
        expect(client.create_new_product('junk')).to eq 2875142
      end

      it 'create new product fails' do        
        expect(client.create_new_product('fail')).to be_falsey
      end

    end
  end
end
