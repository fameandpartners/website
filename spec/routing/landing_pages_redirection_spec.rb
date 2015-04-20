require 'spec_helper'

describe 'Landing Pages', type: :request do
  context "'amfam' renamed to 'wicked game'" do
    it_will :redirect, '/amfam',         '/wicked-game-collection'
    it_will :redirect, '/amfam-dresses', '/wicked-game-collection'
  end
end
