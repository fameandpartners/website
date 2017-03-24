require 'spec_helper'

describe RedirectedSearchTerm do
  it "should not allow the same term to be saved twice" do
    first =  RedirectedSearchTerm.new( {term: 'prom', redirect_to: '/dresses' })
    expect( first.save ).to be_truthy

    second =  RedirectedSearchTerm.new( {term: 'prom', redirect_to: '/dresses' })
    expect( second.save ).to be_falsey
    expect( second.errors.empty? ).to be_falsey
  end

  it "should always save the lowercase version of the term" do
    first =  RedirectedSearchTerm.new( {term: 'Prom', redirect_to: '/dresses' })
    expect( first.save ).to be_truthy

    expect(first.term).to eq('prom')
  end

  it "should always require a redirect_to" do
    first =  RedirectedSearchTerm.new( {term: 'Prom', redirect_to: '' })
    expect( first.save ).to be_falsey
  end

  it "should always require a term" do
    first =  RedirectedSearchTerm.new( {term: '', redirect_to: '/dresses' })
    expect( first.save ).to be_falsey
  end

  it "should save a full url" do
    first =  RedirectedSearchTerm.new( {term: 'prom', redirect_to: 'http://example.com/dresses' })
    expect( first.save ).to be_truthy
    expect( first.redirect_to ).to eq( 'http://example.com/dresses' )
  end

  it "should trim the end / off of a url" do
    first =  RedirectedSearchTerm.new( {term: 'prom', redirect_to: '/dresses/' })
    expect( first.save ).to be_truthy
    expect(first.redirect_to).to eq( '/dresses' )
    
  end

  it "should add a leading / to a url" do
    first =  RedirectedSearchTerm.new( {term: 'prom', redirect_to: 'dresses' })
    expect( first.save ).to be_truthy
    expect(first.redirect_to).to eq( '/dresses' )
  end
  
  
  
  
  
end
