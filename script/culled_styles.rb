namespace :data do
desc 'Hide styles in spree'
  task :hiding_styles=> :environment do
    culled_styles = [
    'FP2367',
    'FP2367',
    'FP2367',
    'FP2421',
    'FP2309',
    'FP2428',
    'FP2329',
    'FP2423',
    'FP2329P',
    'FP2376',
    'FP2350P',
    'FP2405',
    'FP2350',
    'FP2344',
    'FP2126B',
    'FP2095',
    'FP2155',
    'FP2201',
    'FP2020',
    'FP2232',
    'FP2112',
    'FP2160',
    'C161006',
    'C161051',
    'C161003',
    'FP2198',
    'FP2323',
    '4B159',
    '4B497',
    'FP2169',
    'FP2102',
    'FP2250',
    'FP2193',
    'FP2164']

    culled_styles.each do | style |
      the_product = Spree::Product.find_by_style_number(style)
      the_product.hidden = true
      the_product.save
    end


  end
end