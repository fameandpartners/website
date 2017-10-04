namespace :data do
    desc 'Seeding categories and linking them to products'
      task :link_products_to_categories=> :environment do
        sku_category_hash = {'FP2154'=>['Dresses', 'Ankle'],
            'FP2582'=>['Pants', 'Pants'],
            'USP1220'=>['Dresses', 'Ankle'],
            'USP1017L'=>['Dresses', 'Maxi'],
            '4B464'=>['Dresses', 'Ankle'],
            'FP2236'=>['Dresses', 'Maxi'],
            '4B130W'=>['Dresses', 'Maxi'],
            '4B568'=>['Dresses', 'Maxi'],
            'FP2263'=>['Dresses', 'Maxi'],
            'USP1040'=>['Dresses', 'Maxi'],
            'FP2287B'=>['Dresses', 'Maxi'],
            'FP2237'=>['Dresses', 'Maxi'],
            'FPMC116'=>['Dresses', 'Maxi'],
            '4B157'=>['Dresses', 'Ankle'],
            'FP2239'=>['Dresses', 'Maxi'],
            'FP2049'=>['Dresses', 'Knee'],
            'FP2243'=>['Dresses', 'Maxi'],
            'FP2241'=>['Dresses', 'Maxi'],
            'FPMC117'=>['Dresses', 'Maxi'],
            'USP1029'=>['Dresses', 'Maxi'],
            'C161028'=>['Dresses', 'Mini'],
            'FP2249'=>['Dresses', 'Maxi'],
            'FP2246'=>['Dresses', 'Maxi'],
            '4B281'=>['Dresses', 'Ankle'],
            'FP2245'=>['Dresses', 'Maxi'],
            'FP2172'=>['Outerwear', 'Kimono'],
            '4B591'=>['Dresses', 'Maxi'],
            'FP2185'=>['Dresses', 'Mini'],
            'FPRV1027'=>['Dresses', 'Maxi'],
            'FP2380'=>['Tops', 'Cami'],
            'FP2230'=>['Dresses', 'Maxi'],
            'FP2011'=>['Dresses', 'Mini'],
            'FP2223'=>['Dresses', 'Maxi'],
            'FP2226'=>['Dresses', 'Maxi'],
            'FP2229'=>['Dresses', 'Maxi'],
            'FP2059'=>['Dresses', 'Maxi'],
            'FP2224'=>['Dresses', 'Maxi'],
            'FP2221'=>['Dresses', 'Maxi'],
            'FP2222'=>['Dresses', 'Maxi'],
            'FP2238'=>['Dresses', 'Maxi'],
            'FP2254'=>['Dresses', 'Maxi'],
            'FPMC118'=>['Dresses', 'Maxi'],
            'FP2255'=>['Dresses', 'Maxi'],
            'FP2252'=>['Dresses', 'Maxi'],
            'FP2251'=>['Dresses', 'Maxi'],
            'FP2254B'=>['Dresses', 'Maxi'],
            'FP2044'=>['Dresses', 'Maxi'],
            'FP2253'=>['Dresses', 'Maxi'],
            'USP1234'=>['Dresses', 'Maxi'],
            'FPMC108'=>['Dresses', 'Maxi'],
            'FP2231'=>['Dresses', 'Maxi'],
            'FP2396'=>['Dresses', 'Maxi'],
            'FP2046'=>['Dresses', 'Maxi'],
            'FP2301'=>['Jumpsuits', 'Jumpsuit (pants)'],
            'USP1012'=>['Dresses', 'Maxi'],
            'FP2433'=>['Dresses', 'Ankle'],
            'FP2406'=>['Dresses', 'Ankle'],
            'FP2431'=>['Dresses', 'Maxi'],
            '4B592LSKT'=>['Dresses', 'Maxi'],
            'FP2305'=>['Dresses', 'Maxi'],
            '4B297W'=>['Dresses', 'Maxi'],
            'FP2434'=>['Dresses', 'Maxi'],
            'FP2438'=>['Dresses', 'Maxi'],
            'FP2302'=>['Jumpsuits', 'Jumpsuit (pants)'],
            'FP2018'=>['Jumpsuits', 'Jumpsuit (pants)'],
            '4B590'=>['Dresses', 'Maxi'],
            'FP2260'=>['Dresses', 'Maxi'],
            'FP2262'=>['Dresses', 'Maxi'],
            'FP2280'=>['Dresses', 'Maxi'],
            'FP2259'=>['Dresses', 'Maxi'],
            'FP2273'=>['Dresses', 'Maxi'],
            'FP2272'=>['Dresses', 'Maxi'],
            'FP2256'=>['Dresses', 'Maxi'],
            'FP2261'=>['Dresses', 'Maxi'],
            'FP2261P'=>['Dresses', 'Maxi'],
            'FP2437'=>['Dresses', 'Ankle'],
            'FP2442'=>['Dresses', 'Ankle'],
            'FPRV1012'=>['Dresses', 'Mini'],
            'FP2258'=>['Dresses', 'Maxi'],
            'FP2275'=>['Dresses', 'Maxi'],
            'FP2274'=>['Dresses', 'Maxi'],
            'FPMC126'=>['Dresses', 'Maxi'],
            'FP2286'=>['Dresses', 'Maxi'],
            'FP2284'=>['Dresses', 'Maxi'],
            'FP2282'=>['Dresses', 'Maxi'],
            'FP2099'=>['Skirts', 'Mini'],
            'FP2439'=>['Dresses', 'Petti'],
            'FP2276'=>['Dresses', 'Maxi'],
            'FP2289'=>['Dresses', 'Maxi'],
            'FP2006P'=>['Dresses', 'Maxi'],
            'USP1008'=>['Dresses', 'Maxi'],
            'C161037PSKT'=>['Skirts', 'Maxi'],
            'FP2293'=>['Dresses', 'Maxi'],
            'FP2287P'=>['Dresses', 'Maxi'],
            'FPMC124'=>['Dresses', 'Maxi'],
            'FP2288'=>['Dresses', 'Maxi'],
            '4B107'=>['Dresses', 'Maxi'],
            'FP2287'=>['Dresses', 'Maxi'],
            'FP2313'=>['Dresses', 'Mini'],
            '4B123'=>['Dresses', 'Maxi'],
            'FP2469'=>['Dresses', 'Maxi'],
            'C161017'=>['Dresses', 'Petti'],
            'FP2296B'=>['Dresses', 'Maxi'],
            'FP2294'=>['Dresses', 'Maxi'],
            'FP2048'=>['Dresses', 'Maxi'],
            'FP2295'=>['Dresses', 'Maxi'],
            'FP2006'=>['Dresses', 'Maxi'],
            '4B161'=>['Dresses', 'Maxi'],
            'FP2297'=>['Dresses', 'Maxi'],
            'FP2318'=>['Dresses', 'Knee'],
            'FP2278'=>['Dresses', 'Maxi'],
            'FP2299'=>['Dresses', 'Maxi'],
            'FP2298P'=>['Dresses', 'Maxi'],
            'FP2298'=>['Dresses', 'Maxi'],
            'FP2470'=>['Dresses', 'Maxi'],
            'FP2473'=>['Dresses', 'Maxi'],
            'FP2227'=>['Dresses', 'Maxi'],
            'FP2307'=>['Dresses', 'Maxi'],
            'FP2320'=>['Dresses', 'Maxi'],
            'FP2441'=>['Dresses', 'Maxi'],
            'FP2242'=>['Dresses', 'Maxi'],
            'FP2308'=>['Dresses', 'Maxi'],
            'FP2212S0F1'=>['Dresses', 'Ankle'],
            'FP2471'=>['Dresses', 'Maxi'],
            'FPMC214'=>['Dresses', 'Maxi'],
            'USP1004'=>['Dresses', 'Maxi'],
            'FP2324'=>['Dresses', 'Maxi'],
            'FP2228'=>['Dresses', 'Maxi'],
            'FPMC230'=>['Dresses', 'Maxi'],
            'FP2273M'=>['Dresses', 'Maxi'],
            'FP2359'=>['Dresses', 'Maxi'],
            '4B573'=>['Dresses', 'Maxi'],
            'FP2162'=>['Accessories ', 'Belt'],
            'FPMC266'=>['Dresses', 'Maxi'],
            'FP2212S1F0'=>['Dresses', 'Midi'],
            'FP2212S2F5'=>['Dresses', 'Maxi'],
            'FP2212S2F3'=>['Dresses', 'Maxi'],
            'FP2052'=>['Dresses', 'Maxi'],
            'FP2281'=>['Dresses', 'Maxi'],
            'FPMC107'=>['Dresses', 'Maxi'],
            'FP2212S5F5'=>['Dresses', 'Maxi'],
            'FP2255P'=>['Dresses', 'Maxi'],
            'FP2212S4F2'=>['Dresses', 'Petti'],
            'FP2348'=>['Dresses', 'Mini'],
            'FP2383'=>['Dresses', 'Maxi'],
            'FP2474'=>['Dresses', 'Maxi'],
            'FPMC120'=>['Dresses', 'Maxi'],
            'FP2057'=>['Dresses', 'Maxi'],
            'FP2300'=>['Dresses', 'Maxi'],
            'FP2290'=>['Dresses', 'Maxi'],
            'FP2349'=>['Dresses', 'Mini'],
            'FP2475'=>['Dresses', 'Maxi'],
            'FP2472'=>['Dresses', 'Maxi'],
            'FP2213S1F0'=>['Dresses', 'Midi'],
            'FP2476'=>['Dresses', 'Maxi'],
            'FP2215S5F4'=>['Dresses', 'Midi'],
            'FP2213S3F0'=>['Dresses', 'Petti'],
            'FP2213S4F0'=>['Dresses', 'Petti'],
            'FP2213S5F4'=>['Dresses', 'Ankle'],
            'FP2214S1F0'=>['Dresses', 'Ankle'],
            'FP2214S2F1'=>['Dresses', 'Petti'],
            'FP2214S5F3'=>['Dresses', 'Midi'],
            'FP2215S1F1'=>['Dresses', 'Ankle'],
            'FP2215S2F0'=>['Dresses', 'Ankle'],
            'FP2215S3F0'=>['Dresses', 'Ankle'],
            'FP2216S0F1'=>['Dresses', 'Ankle'],
            '4B300'=>['Dresses', 'Maxi'],
            'FP2478'=>['Dresses', 'Maxi'],
            'FP2216S2F0'=>['Dresses', 'Ankle'],
            'USP1006'=>['Dresses', 'Maxi'],
            'FP2414'=>['Dresses', 'Petti'],
            'FP2476P'=>['Dresses', 'Maxi'],
            'FP2216S4F2'=>['Dresses', 'Maxi'],
            '4B297'=>['Dresses', 'Maxi'],
            'FP2216S4F0'=>['Dresses', 'Ankle'],
            '4B297B'=>['Dresses', 'Maxi'],
            'FP2219S0F1'=>['Dresses', 'Ankle'],
            '4B280'=>['Dresses', 'Maxi'],
            'FP2216S5F0'=>['Dresses', 'Maxi'],
            'FP2218S0F2'=>['Dresses', 'Ankle'],
            'FP2219S0F4'=>['Dresses', 'Ankle'],
            'FP2219S0F5'=>['Dresses', 'Ankle'],
            'FP2218S0F5'=>['Dresses', 'Midi'],
            'FP2218S2F0'=>['Dresses', 'Ankle'],
            'FP2218S5F0'=>['Dresses', 'Maxi'],
            'FP2479'=>['PANTS', 'Pants'],
            'FP2479B'=>['PANTS', 'Pants'],
            'FP2552'=>['PANTS', 'Pants'],
            'FP2219S1F0'=>['Dresses', 'Ankle'],
            '4B276'=>['Dresses', 'Maxi'],
            '4B587'=>['Dresses', 'Maxi'],
            'FPMC295'=>['Dresses', 'Maxi'],
            'FP2219S2F3'=>['Dresses', 'Maxi'],
            'FPSB1097'=>['Dresses', 'Mini'],
            'FPSB1098'=>['Dresses', 'Mini'],
            'FP2219S3F0'=>['Dresses', 'Maxi'],
            'FP2219S4F0'=>['Dresses', 'Maxi'],
            'FP2220S0F5'=>['Dresses', 'Maxi'],
            'FP2220S1F1'=>['Dresses', 'Midi'],
            'FP2220S2F5'=>['Dresses', 'Maxi'],
            'FP2220S2F0'=>['Dresses', 'Maxi'],
            'FP2467'=>['Dresses', 'Maxi'],
            'FP2466'=>['Dresses', 'Maxi'],
            'FP2220S5F0'=>['Dresses', 'Ankle'],
            'FP2220S4F2'=>['Dresses', 'Maxi'],
            'FP2468'=>['Dresses', 'Maxi'],
            'FP2339'=>['TOPS', 'Strapless Top'],
            'FP2340'=>['TOPS', 'Strapless Top'],
            'FP2365P'=>['SKIRTS', 'Maxi'],
            'FP2137'=>['Dresses', 'Maxi'],
            'FP2424'=>['Dresses', 'Midi'],
            'FPRV1024'=>['Dresses', 'Maxi'],
            'FPSB1028'=>['TOPS', 'One Shoulder Top'],
            'FPSB1010'=>['TOPS', 'Cold Shoulder Top'],
            'FP2465'=>['Dresses', 'Maxi'],
            'FP2334'=>['PANTS', 'Pants'],
            'USP1073'=>['Dresses', 'Maxi'],
            'FP2447'=>['Dresses', 'Maxi'],
            'FP2445'=>['Dresses', 'Knee'],
            'FP2446'=>['Dresses', 'Knee'],
            'FP2448'=>['Dresses', 'Mini'],
            'FP2450'=>['Dresses', 'Petti'],
            'FP2449'=>['Dresses', 'Mini'],
            '4B268'=>['Dresses', 'Maxi'],
            'FPSB1069'=>['Tops', 'One Shoulder Top'],
            'FP2061'=>['Dresses', 'Maxi'],
            'FP2319'=>['Dresses', 'Knee'],
            'FPRV1024P'=>['Dresses', 'Maxi'],
            'FP2453'=>['Dresses', 'Ankle'],
            'FP2408'=>['Pants', 'Pants'],
            'FP2454'=>['Dresses', 'Ankle'],
            'FP2457'=>['Dresses', 'midi'],
            'FP2368'=>['Jumpsuits', 'Jumpsuit (pants)'],
            'FP2458'=>['Dresses', 'Petti'],
            '4B301'=>['Dresses', 'Ankle'],
            'FP2463'=>['Jumpsuits', 'Jumpsuit (pants)'],
            'FP2460'=>['Dresses', 'Maxi'],
            'FP2459'=>['Dresses', 'Maxi'],
            'FP2462'=>['Jumpsuits', 'Jumpsuit (pants)'],
            'FP2464'=>['Jumpsuits', 'Jumpsuit (pants)'],
            'FP2345'=>['Pants', 'Pants'],
            'FP2404'=>['Tops', 'Shirt / Blouse'],
            'FP2444'=>['Dresses', 'Mini'],
            '4B450'=>['Dresses', 'Maxi'],
            'FP2283'=>['Dresses', 'Maxi'],
            'FP2557'=>['Jumpsuits', 'Jumpsuit (pants)'],
            'FP2563'=>['Dresses', 'Petti'],
            'FP2564'=>['Jumpsuits', 'Jumpsuit (pants)'],
            'FP2560'=>['Dresses', 'Mini'],
            'FP2555'=>['Dresses', 'Midi'],
            'FP2561'=>['Skirts', 'Mini'],
            'FP2562'=>['Dresses', 'midi'],
            'FP2351P'=>['Dresses', 'Maxi'],
            'FPRV1060'=>['Dresses', 'Mini'],
            'FP2556'=>['Dresses', 'Mini'],
            'FP2558'=>['Dresses', 'Mini'],
            'FP2565'=>['Dresses', 'Mini'],
            'FP2567'=>['Jumpsuits', 'Jumpsuit (pants)'],
            'FP2248ma'=>['Dresses', 'Maxi'],
            'FP2566P'=>['Dresses', 'Maxi'],
            'FP2568P'=>['Jumpsuits', 'Jumpsuit (pants)'],
            'FP2371'=>['Dresses', 'Midi'],
            'FP2569'=>['Jumpsuits', 'Two Piece Set (with pants)'],
            'USP1026SKT'=>['Skirts', 'Maxi'],
            'FP2569P'=>['Pants', 'Pants'],
            'FP2572'=>['Dresses', 'Mini'],
            'FP2570P'=>['Dresses', 'Maxi'],
            'FP2571'=>['Dresses', 'Mini'],
            'FP2573P'=>['Dresses', 'Mini'],
            'FP2377'=>['Tops', 'Shirt / Blouse'],
            'FP2574'=>['Dresses', 'Mini'],
            'FP2579'=>['Jumpsuits', 'Jumpsuit (pants)'],
            'FP2389'=>['Outerwear', 'Blazer'],
            'FP2425'=>['Dresses', 'Petti'],
            'USP1099SKT'=>['Skirts', 'Maxi'],
            'FPRV1010'=>['Dresses', 'Mini'],
            'FP2390'=>['Skirts', 'Petti'],
            'FP2104'=>['Skirts', 'Ankle'],
            '4B366'=>['Dresses', 'Maxi'],
            'FPRV1011'=>['Dresses', 'Mini'],
            'FP2392'=>['Accessories ', 'Belt'],
            '4B396'=>['Dresses', 'Maxi'],
            '4B164'=>['Dresses', 'Maxi'],
            'FPRV1036'=>['Dresses', 'Mini'],
            '4B054'=>['Dresses', 'Maxi'],
            'FP2244'=>['Dresses', 'Maxi'],
            '4B567'=>['Dresses', 'Maxi'],
            'FP2393'=>['Pants', 'Pants'],
            'FP2398'=>['Dresses', 'Ankle'],
            '4B643'=>['Dresses', 'Mini'],
            'FP2395'=>['Jumpsuits', 'Jumpsuit (pants)'],
            'FP2369'=>['Tops', 'Shirt / Blouse'],
            'FP2382'=>['Outerwear', 'Blazer'],
            'FP2412'=>['Tops', 'Cold Shoulder Top'],
            'FP2394'=>['Dresses', 'Maxi'],
            'FP2212S3F5'=>['Dresses', 'Maxi'],
            'FP2409'=>['Dresses', 'Ankle'],
            'FP2375'=>['Dresses', 'Knee'],
            '4B316'=>['Dresses', 'Maxi'],
            '4B196'=>['Dresses', 'Maxi'],
            'FP2113'=>['Dresses', 'midi'],
            'FP2037'=>['Dresses', 'Maxi'],
            'FP2415'=>['Dresses', 'Knee'],
            'FP2399'=>['Dresses', 'Ankle'],
            '4B398'=>['Dresses', 'Maxi'],
            '4B555'=>['Dresses', 'Maxi'],
            '4B466'=>['Dresses', 'Maxi'],
            '4B497'=>['Jumpsuits', 'Jumpsuit (pants)'],
            '4B506B'=>['Dresses', 'Midi'],
            '4B316SKT'=>['Skirts', 'Maxi'],
            '4B305'=>['Dresses', 'Maxi'],
            '4B501'=>['Dresses', 'Maxi'],
            '4B511'=>['Dresses', 'Maxi'],
            '4B480'=>['Dresses', 'Maxi'],
            '4B540'=>['Dresses', 'Maxi'],
            'FP2418'=>['Skirts', 'Petti'],
            'FP2357'=>['Dresses', 'Maxi'],
            '4B277'=>['Dresses', 'Maxi'],
            'FP2335'=>['Tops', 'Shirt / Blouse'],
            'FP2420'=>['Tops', 'Cold Shoulder Top'],
            'FP2086'=>['Skirts', 'Midi'],
            'FP2336P'=>['Tops', 'Shirt / Blouse'],
            'FP2417'=>['Skirts', 'Petti'],
            'FP2355P'=>['Skirts', 'Maxi'],
            'FP2354'=>['Outerwear', 'Cape'],
            '4B386'=>['Skirts', 'Maxi'],
            '4B462'=>['Dresses', 'Midi'],
            'FP2356'=>['Skirts', 'Maxi'],
            'FP2355'=>['Skirts', 'Maxi'],
            'FP2426'=>['Dresses', 'midi'],
            'FP2100'=>['Skirts', 'Mini'],
            'FP2351'=>['Dresses', 'Maxi'],
            'FP2184'=>['Dresses', 'Maxi'],
            'FP2358'=>['Pants', 'Pants'],
            'FP2353'=>['Outerwear', 'Blazer'],
            'C161008SKT'=>['Skirts', 'Mini'],
            'USP1068'=>['Skirts', 'Maxi'],
            'FPRV1026P'=>['Dresses', 'Maxi'],
            'FPSB1043'=>['Tops', 'Cold Shoulder Top'],
            'FPRV1026'=>['Dresses', 'Maxi'],
            'FPSB1010P'=>['Tops', 'Cold Shoulder Top'],
            'FPSB1094'=>['Dresses', 'Knee'],
            '4B130'=>['Dresses', 'Maxi'],
            'USP1060'=>['Dresses', 'Maxi'],
            '4B141'=>['Dresses', 'Maxi'],
            'C161049'=>['Tops', 'Halter'],
            'FP2045'=>['Dresses', 'Maxi'],
            '4B408'=>['Dresses', 'Maxi'],
            '1310029W'=>['dresses', 'Maxi'],
            '1310023CL'=>['Dresses', 'Maxi'],
            'FP2186'=>['Dresses', 'Mini'],
            '4B627BSKT'=>['Skirts', 'Ankle'],
            'USP1074P'=>['Dresses', 'Maxi'],
            'FP2029'=>['Dresses', 'midi'],
            'FP2050'=>['Dresses', 'Maxi'],
            'FP2051'=>['Dresses', 'Maxi'],
            '4B113'=>['Dresses', 'Maxi'],
            'FP2069'=>['Skirts', 'Petti'],
            'FP2071B'=>['Skirts', 'midi'],
            '4B094'=>['Dresses', 'Maxi'],
            'C161019'=>['Dresses', 'Maxi'],
            'USP1074PSKT'=>['Skirts', 'Maxi'],
            'FP2090'=>['Skirts', 'Maxi'],
            'USP1072SKT'=>['Skirts', 'Maxi'],
            '4B481SKT'=>['Skirts', 'Maxi'],
            '4B064'=>['Dresses', 'Maxi'],
            'FP2067'=>['Skirts', 'Maxi'],
            '4B636'=>['Dresses', 'Maxi'],
            '4B164L'=>['Dresses', 'maxi'],
            'USP1023'=>['Dresses', 'maxi'],
            '4B398L'=>['Dresses', 'Maxi'],
            '4B464B'=>['Dresses', 'Mini'],
            'USP1003'=>['Dresses', 'Maxi'],
            'USP1001'=>['Dresses', 'Maxi'],
            'USP1007'=>['Dresses', 'Maxi'],
            'USP1008D'=>['Dresses', 'Maxi'],
            'USP1016'=>['Dresses', 'Maxi'],
            'USP1014'=>['Dresses', 'Maxi'],
            'USP1018'=>['Dresses', 'Maxi'],
            'USP1017'=>['Dresses', 'Maxi'],
            'USP1022'=>['Dresses', 'Maxi'],
            'USP1013'=>['Dresses', 'Maxi'],
            'USP1015'=>['Dresses', 'Maxi'],
            'USP1024'=>['Dresses', 'Maxi'],
            'USP1025'=>['Dresses', 'Maxi'],
            'USP1033'=>['Dresses', 'Maxi'],
            'USP1072'=>['Dresses', 'Maxi'],
            'USP1083'=>['Dresses', 'midi'],
            'USP1096'=>['Dresses', 'Maxi'],
            'USP1045'=>['Dresses', 'Maxi'],
            'USP1047'=>['Dresses', 'Ankle'],
            'USP1078'=>['Dresses', 'Maxi'],
            'FP2157'=>['Dresses', 'Mini'],
            'USP1223P'=>['Dresses', 'Petti'],
            'C161025'=>['Dresses', 'Petti'],
            'C161029'=>['Dresses', 'Midi'],
            'USP1079P'=>['Dresses', 'Maxi'],
            'C161042P2'=>['Dresses', 'Maxi'],
            'C161041'=>['Dresses', 'Maxi'],
            'C161021'=>['Dresses', 'Knee'],
            'C161046'=>['Dresses', 'Maxi'],
            'C161038'=>['Dresses', 'Maxi'],
            'C161037'=>['Dresses', 'Maxi'],
            'C161002'=>['Dresses', 'Petti'],
            'C161001'=>['Dresses', 'Petti'],
            'C161024'=>['Dresses', 'Maxi'],
            'C161044B'=>['Dresses', 'Mini'],
            'C161045'=>['Dresses', 'Maxi'],
            'FP2021'=>['Dresses', 'Maxi'],
            'FP2029P'=>['Dresses', 'Midi'],
            'C161050'=>['Pants', 'Pants'],
            'FP2034P'=>['Dresses', 'Maxi'],
            'FP2033'=>['Dresses', 'Maxi'],
            'C161043'=>['Dresses', 'Petti'],
            'C161054'=>['Dresses', 'Petti'],
            'FP2015P'=>['Dresses', 'Maxi'],
            'FP2014'=>['Dresses', 'Maxi'],
            'FP2055'=>['Dresses', 'Maxi'],
            'FP2144'=>['Dresses', 'Maxi'],
            'FP2064'=>['Dresses', 'Maxi'],
            'FP2146'=>['Dresses', 'Maxi'],
            'FP2141'=>['Dresses', 'Maxi'],
            'FP2039'=>['Dresses', 'Maxi'],
            'FP2062'=>['Dresses', 'Maxi'],
            'FP2187'=>['Dresses', 'Maxi'],
            'FP2188'=>['Dresses', 'Maxi'],
            'FP2063'=>['Dresses', 'Maxi'],
            'FP2042'=>['Dresses', 'Maxi'],
            'FP2199'=>['Dresses', 'Mini'],
            'FP2148'=>['Dresses', 'Midi'],
            'FP2197'=>['Dresses', 'Midi'],
            'FP2192B'=>['Dresses', 'Maxi'],
            'FP2211'=>['Dresses', 'Petti'],
            'FP2136'=>['Dresses', 'Maxi'],
            'FP2192'=>['Dresses', 'Petti'],
            'FP2191'=>['Dresses', 'Mini'],
            'FP2191B'=>['Dresses', 'Mini'],
            'FP2203'=>['Dresses', 'Mini'],
            'FP2208'=>['Dresses', 'Midi'],
            'FP2098'=>['Dresses', 'Mini'],
            'FP2164B'=>['Dresses', 'Maxi'],
            'FP2118'=>['Dresses', 'Maxi'],
            'FP2265'=>['Dresses', 'Maxi'],
            'FP2266'=>['Dresses', 'Maxi'],
            'FP2269'=>['Dresses', 'Maxi'],
            'FP2267'=>['Dresses', 'Ankle']}


        sku_category_hash.each_pair{|key,value| link_product_category(key, value[0], value[1])}


        unassigned = Spree::Product.where(:category_id => nil)

        cat = Category.where({category: 'Unknown', subcategory: 'Unknown'}).first
        if(cat.nil?)
            cat = Category.new()
            cat.category = 'Unknown'
            cat.subcategory = 'Unknown'
            cat.save!
        end
        unassigned.each do|product|
            product.category = cat
            product.save!
        end
    end
end

def link_product_category(style_number, category, subcategory)

    cat = Category.where({category: category, subcategory: subcategory}).first
    if(cat.nil?)
        cat = Category.new()
        cat.category = category
        cat.subcategory = subcategory
        cat.save!
    end
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
        puts "#{style_number} failed to link #{category}, #{subcategory}"
    end

  
end  