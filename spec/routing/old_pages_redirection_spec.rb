
require 'spec_helper'

describe 'Old Pages Redirection', type: :request do

  it_will :redirect, '/how-it-works', '/why-us'

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
    it_will :redirect, '/blog', 'http://blog.fameandpartners.com'
    it_will :redirect, '/blog/anything/else?really=true', 'http://blog.fameandpartners.com'
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
    it_will :redirect, '/dresses/dress-my-dress-slug/blank', '/dresses/dress-my-dress-slug?color=blank'
    it_will :redirect, '/dresses/dress-my-dress-slug/blank?utm_source=platform&query_string=other', '/dresses/dress-my-dress-slug?color=blank&query_string=other&utm_source=platform'

    context 'site_version on the path will not be duplicated on the query string' do
      it_will :not_redirect, '/au/dresses/dress-my-dress-slug/blank', '/dresses/dress-my-dress-slug?color=blank&site_version=au'
      it_will :redirect, '/au/dresses/dress-my-dress-slug/blank', '/dresses/dress-my-dress-slug?color=blank'
    end
  end

  context 'bridesmaid party' do
    it_will :redirect, '/bridesmaid-party', '/bridesmaid-dresses'
    it_will :redirect, '/bridesmaid-party/anything/else/really', '/bridesmaid-dresses'
  end
end
