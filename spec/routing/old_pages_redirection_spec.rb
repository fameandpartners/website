
require 'spec_helper'

describe 'Old Pages Redirection', type: :request do

  it_will :redirect, '/how-it-works', '/why-us'

  context 'fashionitgirl2015' do
    it_will :redirect, '/fashionitgirl2015-terms-and-conditions', '/it-girl'
    it_will :redirect, '/fashionitgirl2015-competition', '/it-girl'
  end

  context 'old statics' do
    it_will :redirect, '/fashionista2014', '/it-girl'
    it_will :redirect, '/nyfw-comp-terms-and-conditions', '/it-girl'
    it_will 'redirect to root', '/fame2015'
  end

  context 'blog' do
    it_will :redirect, '/blog', 'http://blog.fameandpartners.com'
    it_will :redirect, '/blog/anything/else?really=true', 'http://blog.fameandpartners.com'

    it_will :redirect, '/au/blog', 'http://blog.fameandpartners.com'
    it_will :redirect, '/au/blog/anything/else?really=true', 'http://blog.fameandpartners.com'
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

    it_will :redirect, '/au/collection'               , '/au/dresses'
    it_will :redirect, '/au/collection/anything/else' , '/au/dresses'
    it_will :redirect, '/collection'                  , '/dresses'
    it_will :redirect, '/collection/anything/else'    , '/dresses'
  end

  context 'dresses' do
    it_will :redirect, '/dresses/dress-my-dress-slug/blank', '/dresses/dress-my-dress-slug?color=blank'
    it_will :redirect, '/dresses/dress-my-dress-slug/blank?utm_source=platform&query_string=other', '/dresses/dress-my-dress-slug?color=blank&query_string=other&utm_source=platform'

    context 'site_version on the path will not be duplicated on the query string' do
      it_will :not_redirect, '/au/dresses/dress-my-dress-slug/blank', '/dresses/dress-my-dress-slug?color=blank&site_version=au'
      it_will :redirect, '/au/dresses/dress-my-dress-slug/blank', '/dresses/dress-my-dress-slug?color=blank'
    end
  end

  context 'returns' do
    it_will :redirect, '/returns', '/faqs#collapse-returns-policy'
  end

  context 'bridesmaid party' do
    it_will :redirect, '/bridesmaid-party', '/bridesmaid-dresses'
    it_will :redirect, '/bridesmaid-party/anything/else/really', '/bridesmaid-dresses'
  end

  context 'bridesmaid pre registral' do
    it_will :redirect, '/pre-register-bridal', '/bespoke-bridal-collection'
  end

  context 'contact page' do
    it_will :redirect, '/contact/new', '/contact'
  end
end
