
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

  context 'returns' do
    it_will :redirect, '/returns', '/faqs#collapse-returns-policy'
  end

  context 'bridesmaid pre registral' do
    it_will :redirect, '/pre-register-bridal', '/bespoke-bridal-collection'
    it_will :redirect, '/pre-register-bridesmaid', '/wedding-atelier'
  end

  context 'contact page' do
    it_will :redirect, '/contact/new', '/contact'
  end
end
