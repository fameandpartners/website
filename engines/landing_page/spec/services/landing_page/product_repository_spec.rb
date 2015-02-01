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
      q = repo.is_false(field)
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

  describe '.has_discount' do
    context 'with discount value' do
      let(:opts)  { {:discount => 23} }      
      it 'builds discount query' do
        q = repo.has_discount
        expect(q[:bool][:must][:term]).to eq('product.discount' => opts[:discount])
      end
    end

    context 'with all discount' do
      let(:opts)  { {:discount => :all} }      
      it 'builds discount range query' do
        q = repo.has_discount
        expect(q[:bool][:should][:range]).to eq('product.discount' => {:gt => 0 })
      end
    end
  end

  describe '.sort_by' do
    let(:opts)  { {:sort_by => 'blah.vtha'} }  
    it 'builds discount range query' do
      expect(repo.sort_by).to include({ opts[:sort_by] => 'desc' })
    end

    context 'with direction' do
      let(:opts)  { {:sort_by => 'blah.vtha', :sort_dir => 'asc'} }  
      it 'builds discount range query' do
        expect(repo.sort_by).to include({ opts[:sort_by] => opts[:sort_dir] })
      end
    end
  end
end