require "spec_helper"
require 'rspec/collection_matchers'

describe Trove::ProductRepository do
  let(:search)    { {} }
  let(:repo)      { Trove::ProductRepository.new(search) }
  let(:opts)      { {} }
  let(:product)   { make_product(opts) }
  let(:products)  { [] }
  let(:colour)    { {:id => 99999999, :name => 'pink', :presentation => 'pink'} }

  before do
    3.times { |_| make_product }
    product #make it exist
    index_products(products)
  end

  it 'works' do
    expect(repo.products).to have(4).product
  end

  context 'featured' do
    let(:opts)    { { :product => {:name => 'vtha', :sku => 'SKU-VTHA'} } }
    let(:search)  { { :featured => ['SKU-VTHA', 'SKU-BLAH'], :sort_by => 'product.name' } }

    before do
      make_product(:product => {:name => 'blah', :sku => 'SKU-BLAH' })
      index_products(products)
    end

    it 'orders featured products' do
      puts "-------------------"
      puts repo.query
      puts "-------------------"
      expect(repo.products).to have(5).product
      a = repo.products[0]
      b = repo.products[1]
      puts "-------------------"
      puts a
      puts b
      puts "-------------------"
      expect(a['product']['name']).to eq 'vtha'
      expect(b['product']['name']).to eq 'blah'
    end
  end


  context 'by keywords' do
    let(:opts)    { { :product => {:name => 'vtha'} } }
    let(:search)  { { :keywords => 'vtha' } }

    it 'finds products by name' do
      expect(repo.products).to have(1).product
    end
  end

  context 'not in stock' do
    let(:opts)     { { :product => {:in_stock => false}} }
    let(:products) { [] }
    it 'finds products by name' do
      expect(repo.products).to be_empty
    end
  end

  context 'not visible' do
    let(:opts)     { { :product => { :is_hidden => true }} }
    let(:products) { [] }
    it 'finds products by name' do
      expect(repo.products).to be_empty
    end
  end

  context 'deleted' do
    let(:opts)     { { :product => { :is_deleted => true }} }
    let(:products) { [] }
    it 'finds products by name' do
      expect(repo.products).to be_empty
    end
  end

  context 'with colors' do
    let(:opts)      { { :color => colour } }
    let(:search)    { { :color_ids => [colour[:id]] } }

    it 'finds product by colour' do
      expect(repo.products).to have(1).product
      expect(repo.products.first['color']['id']).to eq colour[:id]
    end

    context 'sorting colours' do

      let(:color_ids) { [colour[:id], products.first[:color][:id]]  }
      let(:search)    { { :color_ids => color_ids } }

      it 'sorts products by colour' do

        expect(repo.products).to have(2).products
        expect(repo.products.first['id']).to eq products.last[:id]
        expect(repo.products.last['id']).to eq products.first[:id]
      end
    end
  end

  context 'with discount' do
    let(:opts)      {{
                        :product => {
                          :zones => {
                            :us => {
                              :discount => 42
                            }
                          }
                        }
                    }}
    let(:search)    { { :discount => 42 } }

    it 'finds product by discount' do
      expect(repo.products).to have(1).product
    end
  end

  context 'with bodyshapes' do
    let(:opts)      {{
                      :product => {
                        :bodyshapes => {
                          :apple => 1, :column => 3, :athletic => 7
                        }
                      }
                    }}

    let(:search)    { { :bodyshapes => %w(athletic column) } }
    it 'finds product by discount' do
      expect(repo.products).to have(1).product
    end
  end


  # `size_options = create_option_value(size_type, %w{1 2 3 5 8 13 21 34})
  # colour_options = create_option_value(color_type, %w{black white green})
  # "#{%w{Two-Piece Split Strapless Lace V-Neck Lace}.sample} #{n}" }

  def rand_id
    rand(99999)
  end

  def default_opts
    name = %w{elle eva moonlit serpent melody horizon dreamcatcher valentine hazel}.shuffle.first
    colour = %w{black white red green blue yellow}.shuffle.first
    price = rand(999).to_f
    {
      :id       => rand_id,
      :product  => {
        :id                 => rand_id,
        :sku                => rand_id.to_s,
        :name               => name,
        :description        => 'Find an air of elegance with this alluring gown. Add to the ethereal style with shimmering accents, but go for dainty, not daunting, touches of sparkle. ',
        :created_at         => Time.zone.now.utc,
        :available_on       => (Time.zone.now - 1.days).utc,
        :is_deleted         => false,
        :is_hidden          => false,
        :in_stock           => true,
        :tags               => [],
        :bodyshapes         => {
          :apple              => false,
          :pear               => false,
          :athletic           => false,
          :strawberry         => false,
          :hour_glass         => false,
          :column             => false,
          :petite             => false,
        },
        :zones              => {
          :au               => {
            :url            => "/au/#{name}/",
            :price          => rand_id,
            :discount       => 0
          },
          :us               => {
            :url            => "/us/#{name}/",
            :price          => rand_id,
            :discount       => 0
          }
        }
      },
      :color => {
        :id           => rand_id,
        :name         => colour,
        :presentation => colour
      },
      :images   => [{
        :large => '/products/image.png'
      }],
    }
  end

  def make_product(opts = {})
    products << default_opts.deep_merge(opts)
  end

  def index_products(products)
    products = Array.wrap(products)
    # repo.create_index! force: true, type: '_all'
    repo.delete_index!
    products.each { |p| repo.save(p) }
    repo.refresh_index!
  end

end
