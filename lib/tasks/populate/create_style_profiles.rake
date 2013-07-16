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
  figure_types = [:apple, :pear, :strawberry, :hour_glass, :column]
  mask = [0, 0, 0, 5, 10].shuffle

  figure_types.each_with_index do |figure, index|
    profile[figure] = mask[index]
  end
end
