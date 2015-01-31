require "spec_helper"

describe LandingPage::ProductRepository do
  let(:opts)  { {} }
  let(:repo)  { LandingPage::ProductRepository.new(opts) }
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

  describe '.has_keywords' do
    
    context 'with keywords' do
      let(:opts)  { {:keywords => 'sophistication'} }      
      it 'builds multi-match query' do
        q = repo.has_keywords
        expect(q[:multi_match][:fields]).to include('product.name^2')
      end
    end

    context 'without keywords' do
      it 'is nil' do
        expect(repo.has_keywords).to be_nil
      end
    end
  end


end