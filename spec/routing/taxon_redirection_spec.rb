require 'spec_helper'

describe 'Taxon Redirection', type: :request do
  context 'old taxon urls' do
    it_will :redirect, 'dresses/event', '/dresses'
    it_will :redirect, 'dresses/event/graduation', '/dresses/graduation'
    it_will :redirect, 'dresses/style', '/dresses'
    it_will :redirect, 'dresses/style/long', '/dresses/long'
  end

  context 'plus-size' do
    it_will :redirect, '/plus-size', '/dresses/plus-size'
  end

  context '08-2016 mega menu update' do
    it_will :redirect, '/dresses/wedding', '/dresses/bridal'
    it_will :redirect, '/dresses/short', '/dresses/mini'

    it_will :redirect, '/dresses/blue', '/dresses/blue-purple'
    it_will :redirect, '/dresses/white', '/dresses/white-ivory'
  end
end
