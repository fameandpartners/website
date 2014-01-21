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
    end
  end
end

def resize_paperclip_image
  puts 'resize_paperclip_image invoked'
  Spree::Image.all.each { |image| image.attachment.reprocess! }
  # or?
  #bundle exec rake paperclip:refresh:thumbnails class=Spree::Image
end
