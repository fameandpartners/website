namespace :data do
    desc 'Seeding categories and linking them to products'
      task :link_products_to_categories=> :environment do
        MAXI_DRESSES = ['USP1017L',
        '4B464',
        'FP2236',
        '4B130W',
        '4B568',
        'FP2263',
        'USP1040',
        'FP2287B',
        'FP2237',
        'FPMC116',
        '4B157',
        'FP2239',
        'FP2049',
        'FP2243',
        'FP2241',
        'FPMC117',
        'USP1029',
        'C161028',
        'FP2249',
        'FP2246',
        '4B281',
        'FP2245',
        '4B591',
        'FPRV1027',
        'FP2230',
        'FP2223',
        'FP2226',
        'FP2229',
        'FP2059',
        'FP2224',
        'FP2221',
        'FP2222',
        'FP2238',
        'FP2254',
        'FPMC118',
        'FP2255',
        'FP2252',
        'FP2251',
        'FP2254B',
        'FP2044',
        'FP2253',
        'USP1234',
        'FPMC108',
        'FP2231',
        'FP2396',
        'FP2046',
        'USP1012',
        'FP2431',
        '4B592LSKT',
        'FP2305',
        '4B297W',
        'FP2434',
        'FP2438',
        '4B590',
        'FP2260',
        'FP2262',
        'FP2280',
        'FP2259',
        'FP2273',
        'FP2272',
        'FP2256',
        'FP2261',
        'FP2261P',
        'FP2258',
        'FP2275',
        'FP2274',
        'FPMC126',
        'FP2286',
        'FP2284',
        'FP2282',
        'FP2439',
        'FP2276',
        'FP2289',
        'FP2006P',
        'USP1008',
        'FP2293',
        'FP2287P',
        'FPMC124',
        'FP2288',
        '4B107',
        'FP2287',
        '4B123',
        'FP2469',
        'C161017',
        'FP2296B',
        'FP2294',
        'FP2048',
        'FP2295',
        'FP2006',
        '4B161',
        'FP2297',
        'FP2318',
        'FP2278',
        'FP2299',
        'FP2298P',
        'FP2298',
        'FP2470',
        'FP2473',
        'FP2227',
        'FP2307',
        'FP2320',
        'FP2441',
        'FP2242',
        'FP2308',
        'FP2212S0F1',
        'FP2471',
        'FPMC214',
        'USP1004',
        'FP2324',
        'FP2228',
        'FPMC230',
        'FP2273M',
        'FP2359',
        '4B573',
        'FP2162',
        'FPMC266',
        'FP2212S1F0',
        'FP2212S2F5',
        'FP2212S2F3',
        'FP2052',
        'FP2281',
        'FPMC107',
        'FP2212S5F5',
        'FP2255P',
        'FP2212S4F2',
        'FP2348',
        'FP2383',
        'FP2474',
        'FPMC120',
        'FP2057',
        'FP2300',
        'FP2290',
        'FP2349',
        'FP2475',
        'FP2472',
        'FP2213S1F0',
        'FP2476',
        '4B300',
        'FP2478',
        'USP1006',
        'FP2476P',
        'FP2216S4F2',
        '4B297',
        '4B297B',
        '4B280',
        'FP2216S5F0',
        'FP2218S5F0',
        '4B276',
        '4B587',
        'FPMC295',
        'FP2219S2F3',
        'FP2219S3F0',
        'FP2219S4F0',
        'FP2220S0F5',
        'FP2220S2F5',
        'FP2220S2F0',
        'FP2467',
        'FP2466',
        'FP2220S4F2',
        'FP2468',
        'FP2137',
        'FPRV1024',
        'FP2465',
        'USP1073',
        'FP2447',
        '4B268',
        'FP2061',
        'FPRV1024P',
        'FP2460',
        'FP2459',
        '4B450',
        'FP2283',
        'FP2351P',
        'FP2248ma',
        'FP2566P',
        'FP2570P',
        '4B366',
        '4B396',
        '4B164',
        '4B054',
        'FP2244',
        '4B567',
        'FP2394',
        'FP2212S3F5',
        '4B316']

        link_product_category(MAXI_DRESSES, 'Dresses', 'Maxi')

        ANKLE_DRESSES = ['FP2154',
        'USP1220',
        '4B464',
        '4B157',
        '4B281',
        'FP2433',
        'FP2406',
        'FP2437',
        'FP2442',
        'FP2212S0F1',
        'FP2213S5F4',
        'FP2214S1F0',
        'FP2215S1F1',
        'FP2215S2F0',
        'FP2215S3F0',
        'FP2216S0F1',
        'FP2216S2F0',
        'FP2216S4F0',
        'FP2219S0F1',
        'FP2218S0F2',
        'FP2219S0F4',
        'FP2219S0F5',
        'FP2218S2F0',
        'FP2219S1F0',
        'FP2220S5F0',
        'FP2453',
        'FP2454',
        '4B301',
        'FP2104',
        'FP2398',
        'FP2409']

        link_product_category(ANKLE_DRESSES, 'Dresses', 'Ankle')

        ANKLE_SKIRTS = ['FP2104']

        link_product_category(ANKLE_SKIRTS, 'Skirt', 'Ankle')

        BELT_ACCESSORIES = ['FP2162', 'FP2392']

        link_product_category(BELT_ACCESSORIES, 'Accesories', 'Belt')

        BLAZER_OUTERWEAR = ['FP2389','FP2382']

        link_product_category(BLAZER_OUTERWEAR, 'Outerwear', 'Blazer')

        CAMI_TOPS = ['FP2380']

        link_product_category(CAMI_TOPS, 'Tops', 'Cami')

        C_SHOULDER_TOP = ['FPSB1010','FP2412']

        link_product_category(C_SHOULDER_TOP, 'Tops', 'Cold Shoulder Top')

        JUMPSUIT_JUMPSUIT = ['FP2301',
        'FP2302',
        'FP2018',
        'FP2368',
        'FP2463',
        'FP2462',
        'FP2464',
        'FP2557',
        'FP2564',
        'FP2567',
        'FP2568P',
        'FP2579',
        'FP2395']

        link_product_category(JUMPSUIT_JUMPSUIT, 'Jumpsuits', 'Jumpsuit(pants)')

        KIMONO_OUTERWEAR = ['FP2172']

        link_product_category(KIMONO_OUTERWEAR, 'Outerwear', 'Kimono')

        KNEE_DRESS = ['FP2049',
        'FP2318',
        'FP2445',
        'FP2446',
        'FP2319',
        'FP2375']

        link_product_category(KNEE_DRESS, 'Dresses', 'Knee')

        MAXI_SKIRT = ['C161037PSKT',
        'FP2365P',
        'USP1026SKT',
        'USP1099SKT']

        link_product_category(MAXI_SKIRT, 'Skirts', 'Maxi')

        MIDI_DRESS = ['FP2212S1F0',
        'FP2213S1F0',
        'FP2215S5F4',
        'FP2214S5F3',
        'FP2218S0F5',
        'FP2220S1F1',
        'FP2424',
        'FP2457',
        'FP2555',
        'FP2562',
        'FP2371']

        link_product_category(MIDI_DRESS, 'Dresses', 'Midi')

        MINI_SKIRT = ['FP2561', 'FP2099']

        link_product_category(MINI_SKIRT, 'Skirts', 'Mini')

        MINI_DRESS = ['FP2185',
        'FP2011',
        'FPRV1012',
        'FP2313',
        'FP2348',
        'FP2349',
        'FPSB1097',
        'FPSB1098',
        'FP2448',
        'FP2449',
        'FP2444',
        'FP2560',
        'FPRV1060',
        'FP2556',
        'FP2558',
        'FP2565',
        'FP2572',
        'FP2571',
        'FP2573P',
        'FP2574',
        'FPRV1010',
        'FPRV1011',
        'FPRV1036',
        '4B643']

        link_product_category(MINI_DRESS, 'Dresses', 'Mini')

        ONE_SHOULDER_TOP = ['FPSB1028', 'FPSB1069']

        link_product_category(ONE_SHOULDER_TOP, 'Tops', 'One Shoulder Top')

        PANTS = ['FP2582',
        'FP2479',
        'FP2479B',
        'FP2552',
        'FP2334',
        'FP2408',
        'FP2345',
        'FP2569P',
        'FP2393']

        link_product_category(PANTS, 'Pants', 'Pants')

        PETTI_DRESS = ['C161017',
        'FP2212S4F2',
        'FP2213S3F0',
        'FP2213S4F0',
        'FP2214S2F1',
        'FP2414',
        'FP2450',
        'FP2458',
        'FP2563',
        'FP2425']

        link_product_category(PETTI_DRESS, 'Dresses', 'Petti')

        PETTI_SKIRT = ['FP2390']

        link_product_category(PETTI_SKIRT, 'Skirt', 'Petti')

        TOP_BLOUSE = ['FP2404', 'FP2377', 'FP2369']

        link_product_category(TOP_BLOUSE, 'Tops', 'Shirt/Blouse')

        STRAPLESS_TOP = ['FP2339','FP2340']

        link_product_category(STRAPLESS_TOP, 'Tops', 'Strapless Top')

        TWOPIECE_JUMPSUIT = ['FP2569']

        link_product_category(TWOPIECE_JUMPSUIT, 'Jumpsuits', 'Two Piece Set (with pants)')

        UNKNOWN = ['4B196',
        'FP2113',
        'FP2037',
        'FP2415',
        'FP2399',
        '4B398',
        '4B555',
        '4B466',
        '4B497',
        '4B506B',
        '4B316SKT',
        '4B500SKT',
        '4B305',
        '4B501',
        '4B511',
        '4B480',
        '4B540',
        'FP2418',
        'FP2357',
        'FP2419',
        '4B277',
        'FP2335',
        'FP2420',
        'FP2086',
        'FP2336P',
        'FP2417',
        'FP2355P',
        'FP2354',
        'FP2337',
        '4B386',
        '4B462',
        'FP2356',
        'FP2355',
        'FP2426',
        'FP2100',
        'FP2351',
        'FP2184',
        'FP2358',
        'FPRV1005',
        'FP2353',
        'C161008SKT',
        'USP1068',
        'FPRV1037',
        'FPRV1013',
        'FPRV1026P',
        'FPRV1005B',
        'FPSB1003',
        'FPSB1043',
        'FPRV1018',
        'FPSB1002P2',
        'FP2105',
        'FPRV1026',
        'FPSB1010P',
        'FPSB1094',
        '4B130',
        'USP1060',
        '4B141',
        'C161049',
        '4B627SKT',
        'FP2138P',
        '4B487C',
        'FP2045',
        '4B408',
        '1310029W',
        'USP1231SKT',
        '1310023CL',
        'FP2186',
        '4B627BSKT',
        'USP1074P',
        'FP2029',
        'FP2050',
        'FP2051',
        'C161054SKT',
        'C161037SKT',
        '4B113',
        'FP2069',
        'FP2163',
        'FP2071B',
        '4B094',
        'FP2046SKT',
        'C161019',
        'FP2070',
        'USP1074PSKT',
        'FP2090',
        'USP1072SKT',
        '4B481SKT',
        '4B654SKT',
        '4B064',
        'FP2067',
        '4B636',
        '4B164L',
        'USP1023',
        '4B398L',
        '4B464B',
        'USP1003',
        'USP1001',
        'USP1007',
        'USP1008D',
        'USP1016',
        'USP1014',
        'USP1018',
        'USP1017',
        'USP1022',
        'USP1013',
        'USP1015',
        'USP1024',
        'USP1025',
        'USP1033',
        'USP1072',
        'USP1083',
        'USP1096',
        'USP1045',
        'USP1047',
        'USP1078',
        'FP2157',
        'USP1065P',
        'USP1223P',
        'C161025',
        'C161029',
        'USP1079P',
        'C161026',
        'C161042P2',
        'C161041',
        'C161021',
        'C161021P',
        'C161046',
        'C161038',
        'C161037',
        'C161003B',
        'C161047P',
        'C161002',
        'C161001',
        'C161024',
        'C161044B',
        'C161045',
        'FP2021',
        'FP2029P',
        'FP2003',
        'C161050',
        'FP2034P',
        'FP2032',
        'FP2033',
        'C161043B',
        'C161043',
        'C161054',
        'FP2015P',
        'FP2014',
        'FP2055',
        'FP2144',
        'FP2064',
        'FP2146',
        'FP2141',
        'FP2039',
        'FP2150',
        'FP2062',
        'FP2187',
        'FP2188',
        'FP2063',
        'FP2042',
        'FP2199',
        'FP2136P',
        'FP2148',
        'FP2029B',
        'FP2197',
        'FP2192B',
        'FP2211',
        'FP2136',
        'FP2192',
        'FP2196',
        'FP2192P',
        'FP2191',
        'FP2191B',
        'FP2202',
        'FP2203',
        'FP2115',
        'FP2208',
        'FP2147',
        'FP2098',
        'FP2164B',
        'FP2118',
        'FP2176',
        'FP2166',
        'FP2174',
        'FP2147P',
        'FP2159',
        'FP2122',
        'FP2170',
        'FP2265',
        'FP2266',
        'FP2179',
        'FP2268',
        'FP2269',
        'FP2181B',
        'FP2264',
        'FP2267',
        'FP2205',
        'FP2207']

        link_product_category(UNKNOWN, 'Unkown', 'Unkown')


       unassigned = Spree::Product.where(:category_id => nil)

        cat = Category.where({category: 'Unkown', subcategory: 'Unkown'}).first
        if(cat.nil?)
            cat = Category.new()
            cat.category = category
            cat.subcategory = subcategory
            cat.save!
        end
        unassigned.each do|product|
            product.category = cat
            product.save!
        end
    end
end

def link_product_category(style_array, category, subcategory)

    cat = Category.where({category: category, subcategory: subcategory}).first
    if(cat.nil?)
        cat = Category.new()
        cat.category = category
        cat.subcategory = subcategory
        cat.save!
    end
    count = 0
    failures = []
    style_array.each do |style_number|

        # puts "start linking #{style_number} "

        sku = GlobalSku.find_by_style_number(style_number.downcase)

        if(sku.nil?)
            sku = GlobalSku.find_by_style_number(style_number)
        end
        if sku && sku.product
            product= sku.product
            product.category = cat
            product.save!
        else
            failures << style_number
            count += 1
        end
    end
     puts failures.join(',')
     puts "#{count} failed in #{category}, #{subcategory}"
end  
