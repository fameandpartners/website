require 'spec_helper'

describe 'Landing Pages', type: :request do
  context "'amfam' renamed to 'wicked game'" do
    it_will :redirect, '/amfam',         '/wicked-game-collection'
    it_will :redirect, '/amfam-dresses', '/wicked-game-collection'
  end

  context 'bridesmaid redirections' do
    it_will :redirect, '/fameweddings/bridesmaid', '/fameweddings'
    it_will :redirect, '/fameweddings/bride',      '/fameweddings'
    it_will :redirect, '/fameweddings/guest',      '/fameweddings'
  end
end
