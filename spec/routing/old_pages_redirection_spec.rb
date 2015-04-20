
require 'spec_helper'

describe 'Old Pages Redirection', type: :request do

  it 'redirects old /how-it-works page to all /why-us' do
    get "/how-it-works"
    expect(response).to redirect_to("/why-us")
  end

  it 'redirects old /dani-stahl page to root' do
    get "/dani-stahl"
    expect(response).to redirect_to("/")
  end

  context 'fashionitgirl2015' do
    it do
      get "/fashionitgirl2015-terms-and-conditions"
      expect(response).to redirect_to("/")
    end

    it do
      get "/fashionitgirl2015-competition"
      expect(response).to redirect_to("/")
    end
  end

  context 'old statics' do
    it do
      get "/fashionista2014"
      expect(response).to redirect_to("/")
    end

    it do
      get "/nyfw-comp-terms-and-conditions"
      expect(response).to redirect_to("/")
    end

    it do
      get "/fame2015"
      expect(response).to redirect_to("/")
    end
  end

  context 'blog' do
    it do
      get "/bloggers/liz-black"
      expect(response).to redirect_to("/")
    end
  end

  context 'celebrities' do
    describe 'redirects to /dresses' do
      it "/celebrities" do
        get "/celebrities"
        expect(response).to redirect_to('/dresses')
      end

      it "/celebrities/blake-lively" do
        get "/celebrities/blake-lively"
        expect(response).to redirect_to('/dresses')
      end

      it "/featured-bloggers/cool-blogger" do
        get "/featured-bloggers/cool-blogger"
        expect(response).to redirect_to('/dresses')
      end
    end
  end
end
