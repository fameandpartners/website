namespace "db" do
  namespace "populate" do
    desc "create number of dresses with images and properties"
    task dresses: :environment do
      num_of_dresses = 15
      disable_tire_indexes
      create_dresses(num_of_dresses)
      update_tire_indexes
    end
  end
end

def disable_tire_indexes
  Spree::Product.class_eval do
    def update_index
    end
  end
end

def update_tire_indexes
  Tire.index(configatron.elasticsearch.indices.spree_products) do
    delete
    import Spree::Product.all
  end
end

def create_dresses(num_of_dresses = 0)
  num_of_dresses.times do |index|
    dress = create_dress(index)

    create_images(dress)
    create_properties(dress)
  end
end

def create_dress(random_number)
  args = {
    available_on: Time.now,
    name: generate_name,
    price: generate_price,
    description: generate_description,
    featured: ( rand(3) == 2 ),
    sku: "#{random_word}-#{random_number}"
  }
  args[:permalink] = args[:name].downcase.gsub(/\s/, '_')

  product = Spree::Product.create(args)

  #variant = Spree::Variant.new(product_id: product.id)
  #variant.is_master = true
  #variant.save

  product
end

def create_images(product)
  if product.images.count < 4
    images_set = 1 + rand(2) # product1 or product2 folder
    path = File.join(Rails.root, 'lib', 'tasks', 'populate', "product#{images_set}", "picture*")
    Dir[path].each do |file_path|
      add_image_to_product(product, file_path)
    end

    add_celebrity_properties(product, images_set)
  end
end

def add_image_to_product(product, image_path)
  master_variant = product.master
  Spree::Image.create!(
    :attachment => File.open(image_path),
    :viewable_id => master_variant.id,
    :viewable_type => master_variant.class.to_s
  )
end

def create_properties(product)
  {
    short_description: generate_description(10),
    fit: generate_special_notes,
    fabric: generate_fabric,
    weight: '0.75kg'
  }.each do |property_name, property_value|
    product.set_property(property_name, property_value)
  end
end

def add_celebrity_properties(product, index)
  if index == 1
    product.set_property('inspiration', 'Alexa Chung')
    product.set_property('inspiration_photo', 'http://img12.imageshack.us/img12/3876/86zh.jpg')
  else
    product.set_property('inspiration', 'Camilla Bell')
    product.set_property('inspiration_photo', 'http://img12.imageshack.us/img12/3876/86zh.jpg')
  end

  product.set_property('video_id', '19989483')
end

# helper
def random_words
  @random_words ||= [
    "aliquam", "bibendum", "massa", "quis", "placerat", "pharetra", "velit", 
    "posuere", "eleifend", "sapien", "lectus", "purus", "nunc", "egestas",
    "pellentesque", "condimentum", "varius", "augue", "iaculis", "duis",
    "vestibulum", "felis", "lobortis", "lobortis", "etiam", "volutpat",
    "ligula", "quis", "convallis", "viverra", "pellentesque"
  ]
end

def generate_special_notes
  [
    %Q<"15.75"" pit to pit
    12.75"" waist
    31"" shoulder to hem
    5.25"" sleeve length

    Measurements taken from size small
    Model wears size small. Model is 5'8"
  >,
  %Q<
    Fits true to size, take your normal size
    Fitted at the bust and waist, loose at the hip
    Lightweight non-stretchy fabric
    Model is 177cm/ 5'10"" and is wearing a US size 2"
  >][rand(2)]
end

# private
def random_word
  random_words[rand(random_words.size)]
end

def generate_name
  name = Array.new(2) { random_word }
  "#{name.join(' ').capitalize} dress"
end

def generate_description(max_length = nil)
  length = max_length || 20 + rand(40)
  Array.new(length) { random_word }.join(' ').capitalize
end

def generate_fabric
  materials = %w{cotton silk wool leather poliamide}
  material = materials[rand(materials.size)]
  "#{material} 100%"
end

def generate_price
  10 + rand(100)
end
