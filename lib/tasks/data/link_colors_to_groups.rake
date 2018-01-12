namespace :data do
    desc 'create color groups and link colors'
	task :link_color_groups => :environment do
		new_group = Spree::OptionValuesGroup.new
		new_group.option_type_id = 8
		new_group.name = 'orange'
		new_group.presentation = 'Orange'
		new_group.save!
		new_group = Spree::OptionValuesGroup.new
		new_group.option_type_id = 8
		new_group.name = 'yellow'
		new_group.presentation = 'Yellow'
		new_group.save!

		color_hash = {
			'emerald-green' => ['green'],
			'white-and-mint' => ['white-ivory','green'],
			'bright-turquoise' => ['green'],
			'orange' => ['orange'],
			'sunset-orange' => ['orange'],
			'burnt-orange' => ['orange'],
			'crosswalk' => ['print'],
			'ornate-midnight-floral' => ['print'],
			'aqua-lily' => ['print'],
			'blue-fallen-leaves' => ['print'],
			'gypsy-scarf' => ['print'],
			'light-romance' => ['print'],
			'black-and-white-spot' => ['print'],
			'garden-at-dusk-floral' => ['print'],
			'betsey-floral' => ['print'],
			'love-in-bloom' => ['print'],
			'navy-and-white-gingham' => ['print'],
			'oasis-floral' => ['print'],
			'white-and-red-stripe' => ['print'],
			'young-love-floral' => ['print'],
			'white-and-black-spot' => ['print'],
			'sweet-romance-floral' => ['print'],
			'black-and-tan-spot' => ['print'],
			'midnight-bloom' => ['print'],
			'black-and-white-stripe' => ['print'],
			'faded-floral' => ['print'],
			'lemon' => ['yellow'],
			'yellow' => ['yellow'],
			'bright-yellow' => ['yellow'],
			'cream' => ['white-ivory'],
			'ivory-and-navy' => ['white-ivory','blue'],
			'black-and-white' => ['white-ivory','black'],
			'ivory-and-pink' => ['pink','white-ivory'],
			'pastel-pink' => ['pink','pastel'],
			'black-and-pale-pink' => ['pink','pastel'],
			'vibrant-pink' => ['pink'],
			'navy-and-pretty-pink' => ['pink','blue'],
			'bright-blush' => ['pink'],
			'ocean' => ['blue'],
			'pale-blue-stripe' => ['blue'],
			'royal-blue' => ['blue'],
			'ocean' => ['blue'],
			'red-and-navy' => ['blue','red'],
			'candy-blue' => ['blue'],
			'navy-and-red' => ['blue','red'],
			'icing-pink-and-red' => ['pink','red'],
			'red-and-pretty-pink' => ['pink','red'],
			'black-and-purple' => ['black','purple'],
			'pale-nude' => ['pastel','nude-tan'],
			'chartreuse' => ['green'],
			'dusty-rose' => ['pink']
			}
		color_hash.each_key do |key|
			link_color_to_group(key, color_hash[key])
		end
	end

	def link_color_to_group(color, groups)
		ov = Spree::OptionValue.find_by_name(color)
		groups.each do |group|
			ovg = Spree::OptionValuesGroup.find_by_name(group)
			ov.option_values_groups << ovg
		end
	end
end