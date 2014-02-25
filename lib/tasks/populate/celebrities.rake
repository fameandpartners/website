require "open-uri"

namespace "db" do
  namespace "populate" do
    desc "do all the celebrity"
    task celebrity: :environment do
      ensure_celebrities_exists(2)
      Celebrity.all.each do |celebrity|
        ensure_celebrity_have_primary_image(celebrity)
        ensure_celebrity_have_moodboard_items(celebrity)
        ensure_celebrity_have_products(celebrity)
        ensure_celebrity_have_product_accessories(celebrity)
      end
    end
  end
end

def ensure_celebrities_exists(required_num = 1)
  celebrities_require_to_create = (required_num - Celebrity.count)
  if celebrities_require_to_create > 0
    celebrities_require_to_create.times do |index|
      create_celebrity(index)
    end
  end
end

def create_celebrity(random_num)
  celebrity = Celebrity.new(
    first_name: random_word,
    last_name: random_word,
    title: generate_text(3),
    quote: generate_text(20),
    body: generate_text(100)
  )
  celebrity.slug = celebrity.title.gsub(/\W/, '-')
  celebrity.save!
  celebrity
end

def ensure_celebrity_have_primary_image(celebrity)
  return if celebrity.primary_image.present?
  image = celebrity.images.new
  image.file = placehold_image('1000x400')
  image.position = 0
  image.is_primary = true
  image.save
end

def ensure_celebrity_have_moodboard_items(celebrity)
  if celebrity.moodboard_items.left.count == 0
    6.times do |index|
      item = celebrity.moodboard_items.left.new
      item.side = 'left'
      item.image = placehold_image("200x#{100 + 100 * rand(5)}")
      item.position = index
      item.save
    end
  end
  if celebrity.moodboard_items.right.count == 0
    6.times do |index|
      item = celebrity.moodboard_items.right.new
      item.image = placehold_image("200x#{100 + 100 * rand(5)}")
      item.position = index
      item.save
    end
  end
end

def ensure_celebrity_have_products(celebrity)
  return if celebrity.products.count > 0
  celebrity.products = Spree::Product.where(id: random_product_ids(4)).to_a
  celebrity.save!
end

def ensure_celebrity_have_product_accessories(celebrity)
  celebrity.products.each do |product|
    accessories = celebrity.accessories.for_product(product)
    if accessories.count == 0
      4.times do |index|
        accessory = celebrity.accessories.new
        accessory.spree_product_id = product.id
        accessory.title = generate_text(3)
        accessory.position = index
        accessory.source = "http://fameandpartners.com"
        accessory.image = placehold_image('200x200')
        accessory.save
      end
    end
  end
end

def placehold_image(size_str)
  data = open("http://placehold.it/#{size_str}")
  data.original_filename = 'placeholdit.gif'
  data
end

def random_product_ids(limit = 4)
  product_ids.shuffle.first(4)
end

def product_ids
  @product_ids ||= Spree::Product.active.map(&:id)
end

def generate_text(words_num)
  Array.new(words_num) { random_word }.join(' ')
end

def random_word
  random_words[rand(random_words.size)]
end

def random_words
  @random_words ||= [
    "aliquam", "bibendum", "massa", "quis", "placerat", "pharetra", "velit", 
    "posuere", "eleifend", "sapien", "lectus", "purus", "nunc", "egestas",
    "pellentesque", "condimentum", "varius", "augue", "iaculis", "duis",
    "vestibulum", "felis", "lobortis", "lobortis", "etiam", "volutpat",
    "ligula", "quis", "convallis", "viverra", "pellentesque"
  ]
end
