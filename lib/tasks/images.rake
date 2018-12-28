require 'ruby-progressbar'

namespace "images" do
  desc "create required data changes for new design"
  task :reprocess => :environment  do
    images = Spree::Product.active.flat_map(&:images)

    progressbar = ProgressBar.create(:total => images.count)

    images.each do |image|
      ReprocessImageWorker.perform_async(image.id)
      
      # progressbar.format = format_bar('Image')
      progressbar.increment
    end
  end
end

def format_bar(name)
  "%a %e | #{name} %c/%C |%w%i|"
end