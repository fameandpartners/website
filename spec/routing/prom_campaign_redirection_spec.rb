require 'spec_helper'

describe 'Prom Campaign Landing Page', type: :request do

  it 'redirects prom page to landing app' do
    get "/prom"
    expect(response).to redirect_to("http://prom.fameandpartners.com")
  end

  context 'with utm parameters' do
    it 'redirects prom page with utm parameters' do
      get "/prom?utm_source=fb"
      expect(response).to redirect_to("http://prom.fameandpartners.com?utm_source=fb")
    end
  end

  it 'redirects thanks page to snapchat modal' do
    get "/prom/thanksbabe"
    expect(response).to redirect_to("http://prom.fameandpartners.com?snapchat=true")
  end

end
