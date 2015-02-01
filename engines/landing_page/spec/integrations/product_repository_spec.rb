require "spec_helper"
require 'rspec/collection_matchers'

describe LandingPage::ProductRepository do
  let(:repo)    { LandingPage::ProductRepository.new }
  let(:product) { make_product }
  
  before do
    repo.delete_index!
    repo.save(product)
    repo.refresh_index!
    # sleep(1) #wait for the indexing to catch up
  end
  
  it 'works' do
    expect(repo.products).to have(1).product
  end
  context 'by name' do
  end

#   size_options = create_option_value(size_type, %w{1 2 3 5 8 13 21 34})
# colour_options = create_option_value(color_type, %w{black white green})
# "#{%w{Two-Piece Split Strapless Lace V-Neck Lace}.sample} #{n}" }

  def rand_id
    rand(99999)
  end

  def default_opts
    name = ''
    colour = %w{black white green blue yellow}.shuffle.first
    price = rand(999).to_f
    {
      :id       => rand_id,
      :product  => {
        :id                 => rand_id,
        :name               => name,
        :description        => 'description',
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
    opts = default_opts.merge(opts)
  end

  def index_product


  end

end