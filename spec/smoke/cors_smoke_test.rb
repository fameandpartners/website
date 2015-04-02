describe 'CORS Requests' do

  environments = {
    :preproduction => 'http://preprod.fameandpartners.com',
    :production    => 'http://www.fameandpartners.com'
  }

  environments.each do |environment, url|
    describe "the #{environment} environment allows CORS" do
      let(:response) {
         %x[curl --silent -H 'Origin: http://LETMEIN' -D - #{url}]
      }
      it do
        expect(response).to include("Access-Control-Allow-Origin: http://LETMEIN")
        expect(response).to include("Access-Control-Allow-Methods: GET, POST, OPTIONS")
      end
    end
  end
end
