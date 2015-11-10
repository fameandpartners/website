require 'ruby-progressbar'

namespace :update do
  namespace :variants do
    desc 'Regenerate SKUs for product Variants'
    task :skus => :environment do
      scope = Spree::Variant
      total = scope.count

      progressbar = ProgressBar.create(:total => total, format: "Items %c/%C %w")

      scope.find_each do |variant|
        progressbar.increment
        variant.update_column(:sku, variant.generate_sku)
      end

      progressbar.finish
    end
  end
end
