module Newgistics
	module NewgisticsHelper
		KENTUCKY_CONST = {'merchant_id' => configatron.newgistics.kentucky_merchant_id, 'rule_set' => configatron.newgistics.kentucky_rule_set}
		CALIFORNIA_CONST = {'merchant_id' => configatron.newgistics.california_merchant_id, 'rule_set' => configatron.newgistics.california_rule_set}

		STATE_LOCATION_HASH = { 
			"Maine" => KENTUCKY_CONST,
			"Vermont" => KENTUCKY_CONST,
			"New Hampshire" => KENTUCKY_CONST,
			"Massachusetts" => KENTUCKY_CONST,
			"Connecticut" => KENTUCKY_CONST,
			"Rhode Island" => KENTUCKY_CONST,
			"New York" => KENTUCKY_CONST,
			"Pennsylvania" => KENTUCKY_CONST,
			"New Jersey" => KENTUCKY_CONST,
			"Delaware" => KENTUCKY_CONST,
			"Maryland" => KENTUCKY_CONST,
			"Virginia" => KENTUCKY_CONST,
			"North Carolina" => KENTUCKY_CONST,
			"South Carolina" => KENTUCKY_CONST,
			"Georgia" => KENTUCKY_CONST,
			"Florida" => KENTUCKY_CONST,
			"Alabama" => KENTUCKY_CONST,
			"Tennessee" => KENTUCKY_CONST,
			"Kentucky" => KENTUCKY_CONST,
			"West Virgina" => KENTUCKY_CONST,
			"Indiana" => KENTUCKY_CONST,
			"Michigan" => KENTUCKY_CONST,
			"Ohio" => KENTUCKY_CONST,
			"Wisconsin" => KENTUCKY_CONST,
			"Illinois" => KENTUCKY_CONST,
			"Missouri" => KENTUCKY_CONST,
			"Arkansas" => KENTUCKY_CONST,
			"Lousiana" => KENTUCKY_CONST,
			"Iowa" => KENTUCKY_CONST,
			"Minnesota" => KENTUCKY_CONST,
			"North Dakota" => CALIFORNIA_CONST,
			"South Dakota" => CALIFORNIA_CONST,
			"Nebraska" => CALIFORNIA_CONST,
			"Kansas" => CALIFORNIA_CONST,
			"Oklahoma" => CALIFORNIA_CONST,
			"Texas" => CALIFORNIA_CONST,
			"New Mexico" => CALIFORNIA_CONST,
			"Colorado" => CALIFORNIA_CONST,
			"Wyoming" => CALIFORNIA_CONST,
			"Montana" => CALIFORNIA_CONST,
			"Idaho" => CALIFORNIA_CONST,
			"Utah" => CALIFORNIA_CONST,
			"Arizona" => CALIFORNIA_CONST,
			"Washington" => CALIFORNIA_CONST,
			"Oregon"=> CALIFORNIA_CONST,
			"Nevada" => CALIFORNIA_CONST,
			"California" => CALIFORNIA_CONST
		}

		# COUNTRY_LOCATION_HASH = {.  
		# 	"Canada" => KENTUCKY_CONST,
		# 	"Mexico" => KENTUCKY_CONST,
		# 	"Albania" =>KENTUCKY_CONST,
		# 	"Andorra" => KENTUCKY_CONST,
		# 	"Armenia" => KENTUCKY_CONST,
		# 	"Austria" =>KENTUCKY_CONST,
		# 	"Azerbaijan" => KENTUCKY_CONST,
		# 	"Belarus" => KENTUCKY_CONST,
		# 	"Belgium" =>KENTUCKY_CONST,
		# 	"Bosnia and Herzegovina" => KENTUCKY_CONST,
		# 	"Bulgaria" => KENTUCKY_CONST,
		# 	"Croatia" =>KENTUCKY_CONST,
		# 	"Cyprus" => KENTUCKY_CONST,
		# 	"Czech Republic" => KENTUCKY_CONST,
		# 	"Denmark" =>KENTUCKY_CONST,
		# 	"Estonia" => KENTUCKY_CONST,
		# 	"Finland" => KENTUCKY_CONST,
		# 	"France" =>KENTUCKY_CONST,
		# 	"Georgia" => KENTUCKY_CONST,
		# 	"Germany" => KENTUCKY_CONST,
		# 	"Greece" =>KENTUCKY_CONST,
		# 	"Hungary" => KENTUCKY_CONST,
		# 	"Iceland" => KENTUCKY_CONST,
		# 	"Ireland" =>KENTUCKY_CONST,
		# 	"Italy" =>KENTUCKY_CONST,
		# 	"Kazakhstan" => KENTUCKY_CONST,
		# 	"Kosovo" => KENTUCKY_CONST,
		# 	"Latvia" =>KENTUCKY_CONST,
		# 	"Liechtenstein" => KENTUCKY_CONST,
		# 	"Lithuania" => KENTUCKY_CONST,
		# 	"Luxembourg" =>KENTUCKY_CONST,
		# 	"Macedonia" => KENTUCKY_CONST,
		# 	"Malta" => KENTUCKY_CONST,
		# 	"Moldova" =>KENTUCKY_CONST,
		# 	"Monaco" =>KENTUCKY_CONST,
		# 	"Montenegro" => KENTUCKY_CONST,
		# 	"Netherlands" => KENTUCKY_CONST,
		# 	"Norway" =>KENTUCKY_CONST,
		# 	"Poland" => KENTUCKY_CONST,
		# 	"Portugal" => KENTUCKY_CONST,
		# 	"Romania" =>KENTUCKY_CONST,
		# 	"Russia" => KENTUCKY_CONST,
		# 	"San Marino" => KENTUCKY_CONST,
		# 	"Serbia" =>KENTUCKY_CONST,
		# 	"Slovakia" =>KENTUCKY_CONST,
		# 	"Slovania" => KENTUCKY_CONST,
		# 	"Spain" => KENTUCKY_CONST,
		# 	"Sweden" =>KENTUCKY_CONST,
		# 	"Switzerland" => KENTUCKY_CONST,
		# 	"Turkey" => KENTUCKY_CONST,
		# 	"Ukraine" =>KENTUCKY_CONST,
		# 	"United Kingdom " => KENTUCKY_CONST,
		# 	"Holy See (Vatican City)" => KENTUCKY_CONST,
		# 	"Argentina" => KENTUCKY_CONST,
		# 	"Bolivia" => KENTUCKY_CONST,
		# 	"Brazil" => KENTUCKY_CONST,
		# 	"Chile" => KENTUCKY_CONST,
		# 	"Colombia" => KENTUCKY_CONST,
		# 	"Ecuador" => KENTUCKY_CONST,
		# 	"Guyana" => KENTUCKY_CONST,
		# 	"Paraguay" => KENTUCKY_CONST,
		# 	"Peru" => KENTUCKY_CONST,
		# 	"Suriname" => KENTUCKY_CONST,
		# 	"Uruguay" => KENTUCKY_CONST,
		# 	"Venezuela" => KENTUCKY_CONST,
		# 	"Belize" => KENTUCKY_CONST,
		# 	"Costa rica" => KENTUCKY_CONST,
		# 	"El Salvador" => KENTUCKY_CONST,
		# 	"Guatemala" => KENTUCKY_CONST,
		# 	"Honduras" => KENTUCKY_CONST,
		# 	"Panama" => KENTUCKY_CONST,
		# 	"Cuba" => KENTUCKY_CONST,
		# 	"Dominican Republic" => KENTUCKY_CONST,
		# 	"Haiti" => KENTUCKY_CONST,
		# 	"Guadeloupe" => KENTUCKY_CONST,
		# 	"Martinique" => KENTUCKY_CONST,
		# 	"Puerto Rico" => KENTUCKY_CONST,
		# 	"Saint-Barthélemy" => KENTUCKY_CONST,
		# 	"Saint-Martin" => KENTUCKY_CONST
		# 	}
		# TODO: Not Currently used but once we have a european location this saves time figuring out th europe list


		def client

		end

		def get_facitily_by_location(address)
			if address.country_id != 49 # is international
				facility = KENTUCKY_CONST
			else
				facility = STATE_LOCATION_HASH[address.state.name]
			end
			facility
		end

	end

end