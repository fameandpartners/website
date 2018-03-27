namespace :data do
    desc 'Attaching a free fast making option to all dresses'
    task :free_fast_making => :environment do
        Spree::Product.all.each do |product|
            pmo = ProductMakingOption.new
            pmo.option_type = 'free_fast_making'
            pmo.product_id = product.id
            pmo.currency = "USD"
            pmo.price = 0.0
            pmo.active = true
            pmo.save
        end
    end
end
