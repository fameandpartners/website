
require 'spec_helper'

describe 'Old Pages Redirection', type: :request do

  it_will :redirect, '/how-it-works', '/why-us'

  it_will 'redirect to root', '/dani-stahl'

  context 'fashionitgirl2015' do
    it_will 'redirect to root', '/fashionitgirl2015-terms-and-conditions'
    it_will 'redirect to root', '/fashionitgirl2015-competition'
  end

  context 'old statics' do
    it_will 'redirect to root', '/fashionista2014'
    it_will 'redirect to root', '/nyfw-comp-terms-and-conditions'
    it_will 'redirect to root', '/fame2015'
  end

  context 'blog' do
    it_will 'redirect to root', '/bloggers/liz-black'
  end

  context 'celebrities redirects to /dresses' do
    it_will :redirect, '/celebrities',                    '/dresses'
    it_will :redirect, '/celebrities/blake-lively',       '/dresses'
    it_will :redirect, '/featured-bloggers/cool-blogger', '/dresses'
  end

  context 'old collection landing pages' do
    it_will :redirect, '/lp/collection/random_dresses', '/dresses'
    it_will :redirect, '/lp/collection/',               '/dresses'
    it_will :redirect, '/lp/collection',                '/dresses'
  end

  context 'dresses' do
    it_will :redirect, '/black-Dresses', '/dresses/black'
    it_will :redirect, '/anything-Dresses', '/dresses/anything'

    it_will :redirect, '/dresses/dress-my-dress-slug/blank', '/dresses/dress-my-dress-slug?color=blank'
  end
end
