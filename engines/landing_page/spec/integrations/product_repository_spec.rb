require "spec_helper"
require 'rspec/collection_matchers'

describe LandingPage::ProductRepository do
  let(:search)    { {} }
  let(:repo)      { LandingPage::ProductRepository.new(search) }
  let(:opts)      { {} }
  let(:product)   { make_product(opts) }
  let(:products)  { 3.times.collect { |_| make_product } }
  let(:colour)    { {:id => 99999999, :name => 'pink', :presentation => 'pink'} }

  before do 
    products << product
    index_products(products) 
  end

  it 'works' do
    expect(repo.products).to have(4).product
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
    end
  end

  context 'with discount' do
    let(:opts)      { { :product => { :discount => 42 }} }
    let(:search)    { { :discount => 42 } }     
    it 'finds product by discount' do
      expect(repo.products).to have(1).product
    end
  end

  context 'with bodyshapes' do
    let(:opts)      { { :product => { :apple => 1, :column => 3, :athletic => 7 }} }
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
        :name               => name,
        :description        => 'Find an air of elegance with this alluring gown. Add to the ethereal style with shimmering accents, but go for dainty, not daunting, touches of sparkle. ',
        :created_at         => Time.zone.now.utc,
        :available_on       => (Time.zone.now - 1.days).utc,
        :is_deleted         => false,
        :is_hidden          => false,
        :position           => 0,
        :permalink          => '',
        :master_id          => rand_id,
        :in_stock           => true,
        :discount           => 0,
        :can_be_customized  => true,
        :fast_delivery      => true,
        # :is_surryhills      => false,
        :taxon_ids          => [],
        :price              => price,
        
        # bodyshape sorting
        :apple              => false,
        :pear               => false,
        :athletic           => false,
        :strawberry         => false,
        :hour_glass         => false,
        :column             => false,
        :petite             => false,
        :color_customizable => false,

        :urls               => {
          :en_au => "/au/#{name}/",
          :en_us => "/us/#{name}/"
        },
      },
      :color    => {
        :id           => rand_id,
        :name         => colour,
        :presentation => colour
      },
      :images   => [{
        :large => '/products/image.png'
      }],
      :prices   => {
        :aud => rand_id,
        :usd => rand_id
      }
    }
  end

  def make_product(opts = {})
    default_opts.deep_merge(opts)
  end

  def index_products(products)
    products = Array.wrap(products)
    repo.delete_index!
    products.each { |p| repo.save(p) }
    repo.refresh_index!
  end

end