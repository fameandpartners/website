require 'ruby-progressbar'

namespace :quality do
  desc 'regenerate_variant_skus'
  task :regenerate_variant_skus => :environment do

    scope = Spree::Variant
    total = scope.count

    progressbar = ProgressBar.create(:total => total, format: "Items %c/%C %w")

    scope.find_each do |variant|
      progressbar.increment
      variant.generate_sku!
    end

    progressbar.finish

  end
end
