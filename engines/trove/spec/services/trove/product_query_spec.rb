require "spec_helper"

describe Trove::ProductQuery do
  let(:opts)  { {} }
  let(:query)  { Trove::ProductQuery.new(opts) }
  let(:field) { 'field-blah' }

  describe '.build' do
    context 'with no params' do
      it { expect(query.build.class).to eq Hash }
      it { expect(query.build).to_not be_empty }
    end
  end

  describe '.is_true' do
    it 'builds true term bool filter' do
      q = query.is_true(field)
      expect(q[:bool][:must][:term]).to eq(field => true)
    end
  end

  describe '.is_false' do
    it 'builds false term bool filter' do
      q = query.is_false(field)
      expect(q[:bool][:must][:term]).to eq(field => false)
    end
  end

  describe '.filters' do
    context 'with no params' do
      it { expect(query.filters[:bool][:must]).to have(5).items }
    end
  end

  describe '.has_keywords' do

    context 'with keywords' do
      let(:opts)  { {:keywords => 'sophistication'} }
      it 'builds multi-match query' do
        q = query.has_keywords
        expect(q[:multi_match][:fields]).to include('product.name^2')
      end
    end

    context 'without keywords' do
      it 'is nil' do
        expect(query.has_keywords).to be_nil
      end
    end
  end

  describe '.has_discount' do
    context 'with discount value' do
      let(:opts)  { {:discount => 23} }
      it 'builds discount query' do
        q = query.has_discount
        expect(q[:bool][:must][:term]).to eq('product.discount' => opts[:discount])
      end
    end

    context 'with all discount' do
      let(:opts)  { {:discount => :all} }
      it 'builds discount range query' do
        q = query.has_discount
        expect(q[:bool][:should][:range]).to eq('product.discount' => {:gt => 0 })
      end
    end
  end

  describe '.sort_by' do
    let(:opts)  { {:sort_by => 'blah.vtha'} }
    it 'builds discount range query' do
      expect(query.sort_by).to include({ opts[:sort_by] => 'desc' })
    end

    context 'with direction' do
      let(:opts)  { {:sort_by => 'blah.vtha', :sort_dir => 'asc'} }
      it 'builds discount range query' do
        expect(query.sort_by).to include({ opts[:sort_by] => opts[:sort_dir] })
      end
    end
  end
end
