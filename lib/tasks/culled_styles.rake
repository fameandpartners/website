namespace :data do
desc 'Hide styles in spree'
  task :hiding_styles=> :environment do
    culled_styles_first_round = [
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

    culled_styles = [
    'FP2179',
    'FP2429',
    'FPSB1045',
    'FP2337',
    'FP2554',
    'FPSB1080',
    'FP2370',
    'FP2379',
    'FP2381',
    'FP2388',
    'FP2338',
    'FP2436',
    'FPRV1018',
    '4B629SKT',
    'FP2170',
    'FP2159',
    'FP2029B',
    'FP2385',
    'FP2174',
    'FPRV1037',
    'FP2331',
    'FP2150P',
    'FP2166',
    'FP2032',
    'FP2397',
    'FP2166B',
    'FP2419',
    'FP2352',
    'FP2391',
    'FP2115',
    'FP2440',
    'FP2430',
    'FP2304',
    'FP2374',
    'FP2136P',
    'FP2427',
    'C161001',
    'FP2156',
    '4B487C',
    'FP2138P',
    'FP2432',
    'FP2373',
    'FP2384',
    'FPSB1026',
    'FPSB1002P2',
    'FP2400',
    'FP2422',
    'FPSB1044',
    'FPRV102',
    'FP2403',
    'FP2378',
    'FPSB1003',
    'FP2268',
    'FP2202',
    'FP2192P',
    'FP2181B',
    'FP2176',
    'FP2163',
    'FP2150',
    'FP2147P',
    'FP2147',
    'FP2122',
    'FP2105',
    'FP2070',
    'FP2046SKT',
    'C161054SKT',
    'C161047P',
    'C161043B',
    'C161037SKT',
    'C161037P',
    'C161003B',
    '4B654SKT',
    '4B627SKT',
    '4B500SKT',
    'FP2071B',
    'USP1231SKT',
    'USP1065P',
    'FPRV1013',
    'FPRV1005',
    'FP2190',
    'C161021P',
    'FP2196',
    'FP2205',
    'FPRV1032M',
    'FP2435',
    'FP2264',
    'FPRV1032',
    'FP2003',
    'FP2207',
    'FPRV1005B',
    'C161026'
    ]

    puts "Prepare to kill #{culled_styles.count.to_s}"

    count = 0

    culled_styles.each do | style |
      the_variant = Spree::Variant.where('lower(sku) = ?', style.downcase).first

      if the_variant
        the_variant.product.hidden = true
        the_variant.product.save!
        puts "Killed style: #{style}"
        count = count + 1
      else
        puts "Couldn't find #{style}"
      end
    end

    puts "killed a total of: #{count}"
  end
end
