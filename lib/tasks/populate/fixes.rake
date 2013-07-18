namespace "db" do
  namespace "populate" do
    namespace "fixes" do

#      task update_images: environment do
#        bundle exec rake paperclip:refresh:thumbnails CLASS=Spree::Image RAILS_ENV=staging
#      end

#     # if we have more than 1 master variant in product
      task clean_master_variants: :environment do
        clean_master_variants
      end
    end
  end
end

def clean_master_variants
  products_with_masters = Spree::Product.all.map do |product|
    masters = Spree::Variant.where(product_id: product.id, is_master: true)
    if masters.count > 1
      images_count = {}
      masters.each do |variant|
        images_count[variant.id] = variant.images.count
      end
      puts images_count
      real_master = masters.sort{|a, b| images_count[b.id] <=> images_count[a.id]}.first
      puts real_master.id
      masters.each do |master|
        master.destroy if master.id != real_master.id
      end
    end
  end
 end
