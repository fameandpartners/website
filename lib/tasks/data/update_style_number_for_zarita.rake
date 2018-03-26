namespace :data do
	desc 'Update Style Number On Zarita'
	task :update_style_number_on_zarita => :environment do

		prod = Spree::Product.find_by_name('The Zarita Dress')
		prod.variants.each do |variant|
			variant.sku = variant.sku.sub('FP2652','FP3126')
			variant.save
		end
		variant = prod.master
		variant.sku = 'fp3126'
		variant.save

		g_skus = GlobalSku.where(style_number:'fp2652')

		g_skus.each do |global_sku|
			global_sku.sku = global_sku.sku.sub('FP2652','FP3126')
			global_sku.style_number = 'fp3126'
			global_sku.save
		end

		lips = LineItemPersonalization.where(product_id: prod.id)

		lips.each do |lip|
			lip.sku = lip.sku.sub('FP2652','FP3126')
			lip.save
		end
	end
end