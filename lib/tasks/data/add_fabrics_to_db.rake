namespace :data do
    desc 'create color fabrics'
	task :add_fabrics_to_db => :environment do

		file = File.open('./lib/tasks/data/fabric_upload.txt', 'r')
		txt = ''
		txt = file.read
		fabrics = JSON.parse(txt, :symbolize_names => true) 
		fabrics.each do |fabric|
			create_fabric(fabric[:color], fabric[:fabrics])
		end
	end

	def create_fabric(color_name, fabrics)
		color = Spree::OptionValue.find_by_name(color_name) 
		fabrics.each do |fabric|
			fab = Fabric.new
			fab.name = fabric[:name]
			fab.presentation = fabric[:presentation]
			fab.price_aud = fabric[:price_aud]
			fab.price_usd = fabric[:price_usd]
			fab.image_url = fabric[:image_url]
			fab.material = fabric[:material]
			fab.option_value = color
			fab.save!
		end
	end
end