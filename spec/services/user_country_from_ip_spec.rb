require 'spec_helper'

describe UserCountryFromIP do

  let(:geoip)   { double(GeoIP) }
  let(:country) { double('Country', :country_code2 => 'uk')}
  let(:ip)      { '666.666.666.666' }
  let(:service) { UserCountryFromIP.new(ip) }

  before do
    allow(GeoIP).to receive(:new).and_return(geoip)
  end

  it '#country_code' do
    expect(geoip).to receive(:country).with(ip).and_return(country)
    expect(service.country_code).to eq 'uk'
  end

end
