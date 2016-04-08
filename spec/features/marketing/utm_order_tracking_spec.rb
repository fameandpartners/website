require 'spec_helper'

describe 'I’m capturing order UTM stuff now', type: :feature do

  it "captures UTM params" do
    visit '/?utm_campaign=utm_campaign&utm_source=utm_source&utm_medium=utm_medium'

    utm = Marketing::OrderTrafficParameters.last
    expect(utm.utm_campaign).to eq('utm_campaign')
    expect(utm.utm_source).to eq('utm_source')
    expect(utm.utm_medium).to eq('utm_medium')
  end

  it "doesn't capture UTM params" do
    expect { visit('/') }.to_not change { Marketing::OrderTrafficParameters.count }
  end

end
