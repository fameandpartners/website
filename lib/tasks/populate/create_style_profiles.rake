namespace "db" do
  namespace "populate" do
    desc "create random product style profiles"
    task product_style_profiles: :environment do
      generate_style_profiles()
    end
  end
end

def generate_style_profiles
  Spree::Product.all.each do |product|
    profile = product.style_profile || product.build_style_profile
    populate_profile_with_randoms(profile)
  end
end

def populate_profile_with_randoms(profile)
  add_figure_type(profile)
  profile.save
end

def add_figure_type(profile)
  body_shapes = ProductStyleProfile::BODY_SHAPES
  masks = [
    [10, 5, 0, 0, 0, 0, 0],
    [10, 6, 3, 0, 0, 0, 0],
    [10, 7, 5, 3, 0, 0, 0]
  ]
  mask = masks[rand(masks.size)].shuffle
  body_shapes.each_with_index do |shape, index|
    profile[shape] = mask[index]
  end
end
