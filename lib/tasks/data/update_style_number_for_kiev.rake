namespace :data do
	desc 'Update Style Number On kiev'
	task :update_style_number_on_kiev => :environment do

		prod = Spree::Product.find_by_name('The Kiev Dress')
		prod.variants.each do |variant|
			variant.sku = variant.sku.sub('FP2899S','FP2899')
			variant.save
		end
		variant = prod.master
		variant.sku = 'fp2899'
		variant.save

		g_skus = GlobalSku.where(style_number:'fp2899s')

		g_skus.each do |global_sku|
			global_sku.sku = global_sku.sku.sub('FP2899S','FP2899')
			global_sku.style_number = 'fp2899'
			global_sku.save
		end

		lips = LineItemPersonalization.where(product_id:1645)

		lips.each do |lip|
			lip.sku = lip.sku.sub('FP2899S','FP2899')
			lip.save
		end
	end
end