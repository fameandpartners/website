require 'ruby-progressbar'

namespace "images" do
  desc "create required data changes for new design"
  task :reprocess => :environment  do
    images = Spree::Product.not_deleted.flat_map(&:images)

    progressbar = ProgressBar.create(:total => images.count)

    images.each do |image|
      image.attachment.reprocess!

      # progressbar.format = format_bar('Image')
      progressbar.increment
    end
  end
end

def format_bar(name)
  "%a %e | #{name} %c/%C |%w%i|"
end