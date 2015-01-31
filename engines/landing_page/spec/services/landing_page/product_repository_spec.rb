require "spec_helper"

describe LandingPage::ProductRepository do
  let(:repo)  { LandingPage::ProductRepository.new }
  let(:field) { 'field-blah' }
  
  it 'works' do
    repo.products
  end

  describe '.is_true' do
    it 'builds true term bool filter' do
      q = repo.is_true(field)
      expect(q[:bool][:must][:term]).to eq(field => true)
    end
  end

  describe '.is_false' do
    it 'builds false term bool filter' do
      q = repo.is_true(field)
      expect(q[:bool][:must][:term]).to eq(field => false)
    end
  end

  describe '.filters' do


  end

end