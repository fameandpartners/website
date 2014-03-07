namespace :update do
  namespace :variants do
    task :skus => :environment do
      Spree::Variant.where(deleted_at: nil).each do |variant|
        variant.generate_sku!
      end
    end
  end
end
