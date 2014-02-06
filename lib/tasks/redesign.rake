namespace "db" do
  desc "create required data changes for new design"
  task :redesign do
    puts 'default task for namespace'
    Rake::Task['db:redesign:images'].invoke
  end

  namespace "redesign" do
    # image have new extensions
    task images: :environment do
      resize_paperclip_image
      add_designer_notes_to_products
    end
  end
end

def resize_paperclip_image
  puts 'resize_paperclip_image invoked'
  Spree::Image.all.each { |image| image.attachment.reprocess! }
  # or?
  #bundle exec rake paperclip:refresh:thumbnails class=Spree::Image
end

def add_designer_notes_to_products
  default_note = 'Lorem ipsum dolor sit amet, consectetu, integer vel felis sit amet massa conguet.'
  Spree::Product.each do |product|
    product.set_property('designer_notes', default_note)
  end
end
