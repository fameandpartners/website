class AddStatesToUKandGerman < ActiveRecord::Migration
  def up
    uk = Spree::Country.where(name: "United Kingdom").first

    uk_states = [{ abbr: "ALD",	name: "Alderney"},
    { abbr: "ATM",	name: "County Antrim"},
    { abbr: "ARM",	name: "County Armagh"},
    { abbr: "AVN",	name: "Avon"},
    { abbr: "BFD",	name: "Bedfordshire"},
    { abbr: "BRK",	name: "Berkshire"},
    { abbr: "BDS",	name: "Borders"},
    { abbr: "BUX",	name: "Buckinghamshire"},
    { abbr: "CBE",	name: "Cambridgeshire"},
    { abbr: "CTR",	name: "Central"},
    { abbr: "CHS",	name: "Cheshire"},
    { abbr: "CVE",	name: "Cleveland"},
    { abbr: "CLD",	name: "Clwyd"},
    { abbr: "CNL",	name: "Cornwall"},
    { abbr: "CBA",	name: "Cumbria"},
    { abbr: "DYS",	name: "Derbyshire"},
    { abbr: "DVN",	name: "Devon"},
    { abbr: "DOR",	name: "Dorse"},
    { abbr: "DWN",	name: "County Down"},
    { abbr: "DGL",	name: "Dumfries and Galloway"},
    { abbr: "DHM",	name: "County Durham"},
    { abbr: "DFD",	name: "Dyfed"},
    { abbr: "ESX",	name: "Essex"},
    { abbr: "FMH",	name: "County Fermanagh"},
    { abbr: "FFE",	name: "Fife"},
    { abbr: "GNM",	name: "Mid Glamorgan"},
    { abbr: "GNS",	name: "South Glamorgan"},
    { abbr: "GNW",	name: "West Glamorgan"},
    { abbr: "GLR",	name: "Gloucester"},
    { abbr: "GRN",	name: "Grampian"},
    { abbr: "GUR",	name: "Guernsey"},
    { abbr: "GWT",	name: "Gwent"},
    { abbr: "GDD",	name: "Gwynedd"},
    { abbr: "HPH",	name: "Hampshire"},
    { abbr: "HWR",	name: "Hereford and Worcester"},
    { abbr: "HFD",	name: "Hertfordshire"},
    { abbr: "HLD",	name: "Highlands"},
    { abbr: "HBS",	name: "Humberside"},
    { abbr: "IOM",	name: "Isle of Man"},
    { abbr: "IOW",	name: "Isle of Wight"},
    { abbr: "JER",	name: "Jersey"},
    { abbr: "KNT",	name: "Kent"},
    { abbr: "LNH",	name: "Lancashire"},
    { abbr: "LEC",	name: "Leicestershire"},
    { abbr: "LCN",	name: "Lincolnshire"},
    { abbr: "LDN",	name: "Greater London"},
    { abbr: "LDR",	name: "County Londonderry"},
    { abbr: "LTH",	name: "Lothian"},
    { abbr: "MCH",	name: "Greater Manchester"},
    { abbr: "MSY",	name: "Merseyside"},
    { abbr: "NOR",	name: "Norfolk"},
    { abbr: "NHM",	name: "Northamptonshire"},
    { abbr: "NLD",	name: "Northumberland"},
    { abbr: "NOT",	name: "Nottinghamshire"},
    { abbr: "ORK",	name: "Orkney"},
    { abbr: "OFE",	name: "Oxfordshire"},
    { abbr: "PWS",	name: "Powys"},
    { abbr: "SPE",	name: "Shropshire"},
    { abbr: "SRK",	name: "Sark"},
    { abbr: "SLD",	name: "Shetland"},
    { abbr: "SOM",	name: "Somerset"},
    { abbr: "SFD",	name: "Staffordshire"},
    { abbr: "SCD",	name: "Strathclyde"},
    { abbr: "SFK",	name: "Suffolk"},
    { abbr: "SRY",	name: "Surrey"},
    { abbr: "SXE",	name: "East Sussex"},
    { abbr: "SXW",	name: "West Sussex"},
    { abbr: "TYS",	name: "Tayside"},
    { abbr: "TWR",	name: "Tyne and Wear"},
    { abbr: "TYR",	name: "County Tyrone"},
    { abbr: "WKS",	name: "Warwickshire"},
    { abbr: "WIL",	name: "Western Isles"},
    { abbr: "WMD",	name: "West Midlands"},
    { abbr: "WLT",	name: "Wiltshire"},
    { abbr: "YSN",	name: "North Yorkshire"},
    { abbr: "YSS",	name: "South Yorkshire"},
    { abbr: "YSW",	name: "West Yorkshire"}]

    uk_states.each do |s|
      uk.states.create!(name: s[:name], abbr: s[:abbr])
    end
    uk.states_required = true
    uk.save!


    german_states = [{abbr: "DE-BW"	, name: "Baden-Württemberg" },
    {abbr: "DE-BY"	, name: "Bayern" },
    {abbr: "DE-BE"	, name: "Berlin" },
    {abbr: "DE-BB"	, name: "Brandenburg" },
    {abbr: "DE-HB"	, name: "Bremen" },
    {abbr: "DE-HH"	, name: "Hamburg" },
    {abbr: "DE-HE"	, name: "Hessen	" },
    {abbr: "DE-MV"	, name: "Mecklenburg-Vorpommern" },
    {abbr: "DE-NI"	, name: "Niedersachsen" },
    {abbr: "DE-NW"	, name: "Nordrhein-Westfalen" },
    {abbr: "DE-RP"	, name: "Rheinland-Pfalz" },
    {abbr: "DE-SL"	, name: "Saarland" },
    {abbr: "DE-SN"	, name: "Sachsen" },
    {abbr: "DE-ST"	, name: "Sachsen-Anhalt" },
    {abbr: "DE-SH"	, name: "Schleswig-Holstein" },
    {abbr: "DE-TH"	, name: "Thüringen" }]

    ge =  Spree::Country.where(name: "Germany").first
    german_states.each do |s|
      ge.states.create!(name: s[:name], abbr: s[:abbr])
    end
    ge.states_required = true
    ge.save!
  end

  def down
    #NOOP
  end
end
