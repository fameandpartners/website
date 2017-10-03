module SizeChart
  module_function

  def chart(chart_name)
    CHARTS.fetch(chart_name) { DEFAULT_CHART }
  end

  def size_chart_2016_v2
    size_set = [
      [ 4 ,   0 ,  "81",     "32",    69,   "27",    "64",     "25",   "89",      "35"],
      [ 6 ,   2 ,  "84",     "33",    71,   "28",    "66",     "26",   "92",      "36"],
      [ 8 ,   4 ,  "86",     "34",    74,   "29",    "69",     "27",   "94",      "37"],
      [10 ,   6 ,  "89",     "35",    76,   "30",    "71",     "28",   "97",      "38"],
      [12 ,   8 ,  "93",     "36.5",  80,   "31.5",  "75",     "29.5", "100",   "39.5"],
      [14 ,  10 ,  "97",     "38",    84,   "33",    "79",     "31",   "104",     "41"],
      [16 ,  12 , "100",     "39.5",  88,   "34.5",  "83",     "32.5", "108",   "42.5"],
      [18 ,  14 , "105",     "41.5",  93,   "36.5",  "88",     "34.75", "114",   "44.75"],
      [20 ,  16 , "111",     "43.5",  98,   "38.5",  "94",     "37",   "119",     "47"],
      [22 ,  18 , "116",     "45.5",  103,  "40.5",  "100",    "39.25", "125",   "49.25"],
      [24 ,  20 , "121",     "47.5",  108,  "42.5",  "103",    "41.5", "131",   "51.5"],
      [26 ,  22 , "126",     "49.5",  113,  "44.5",  "111",    "43.75", "137",   "53.75"],
      [28 ,  24 , "131",     "51.5",  118,  "46.5",  "117",    "46",   "142",     "56"],
      [30 ,  26 , "136",     "53.5",  124,  "48.5",  "123",    "48.25", "148",   "58.25"],
    ]

    make_size_chart(size_set)
  end

  def size_chart_2016
    size_set = [
      [ 4 ,  0 ,  78   , "30.75" ,  66   ,  26      , 60   , "23.5" ,  84   , 33    ],
      [ 6 ,  2 ,  80.5 , "31.75" ,  68.5 ,  27      , 62.5 , "24.5" ,  86.5 , 34    ],
      [ 8 ,  4 ,  83   , "32.75" ,  71   ,  28      , 65   , "25.5" ,  89   , 35    ],
      [10 ,  6 ,  88   , "34.75" ,  76   ,  30      , 70   , "27.5" ,  94   , 37    ],
      [12 ,  8 ,  93   , "36.5" ,  81   ,  "31.75"  , 75   , "29.5" ,  99   , 39    ],
      [14 , 10 ,  98   , "38.5" ,  86   ,  "33.75"  , 80   , "31.5" , 104   , 41    ],
      [16 , 12 , 103   , "40.5" ,  91   ,  "35.75"  , 85   , "33.5" , 109   , 43    ],
      [18 , 14 , 109   , 43     ,  97   ,  "38.25"  , 91   , "35.75" , 116.5 , "45.75"],
      [20 , 16 , 116   , "45.75" ,  104  ,  41      , 98   , "38.5" , 123.5 , "48.5"],
      [22 , 18 , 123   , "48.5" ,  111  ,  "43.75"  , 105  , "41.25" , 130.5 , "51.5"],
      [24 , 20 , 130   , "51.25" ,  118  ,  "46.5"  , 112  , 44     , 137.5 , "54.25"],
      [26 , 22 , 137   , 54     ,  125  ,  "49.25"  , 119  , "46.75" , 144.5 , 57    ],
      [28 , 24 , 144   , "56.75" ,  132  ,  52      , 126  , "49.5" , 151.5 , "59.75"],
      [30 , 26 , 151   , "59.5" ,  139  ,  "54.75"  , 133  , "52.25" , 158.5 , "62.5"],
    ]

    make_size_chart(size_set)
  end

  def size_chart_2015
    size_set = [
      [ 4 ,  0 , 32 ,  78   , 31 ,  66   ,  26  , 60   , 24 ,  84   , 35],
      [ 6 ,  2 , 34 ,  80.5 , 32 ,  68.5 ,  27  , 62.5 , 25 ,  86.5 , 36],
      [ 8 ,  4 , 36 ,  83   , 33 ,  71   ,  28  , 65   , 26 ,  89   , 37],
      [10 ,  6 , 38 ,  88   , 35 ,  76   ,  30  , 70   , 28 ,  94   , 39],
      [12 ,  8 , 40 ,  93   , 37 ,  81   ,  32  , 75   , 30 ,  99   , 41],
      [14 , 10 , 42 ,  98   , 39 ,  86   ,  33  , 80   , 31 , 104   , 43],
      [16 , 12 , 44 , 103   , 41 ,  91   ,  35  , 85   , 33 , 109   , 45],
      [18 , 14 , 46 , 109   , 43 ,  97   ,  38  , 91   , 36 , 116.5 , 46],
      [20 , 16 , 48 , 116   , 46 ,  104  ,  41  , 98   , 39 , 123.5 , 49],
      [22 , 18 , 50 , 123   , 48 ,  111  ,  43  , 105  , 41 , 130.5 , 51],
      [24 , 20 , 52 , 130   , 51 ,  118  ,  46  , 112  , 44 , 137.5 , 54],
      [26 , 22 , 54 , 137   , 54 ,  125  ,  49  , 119  , 47 , 144.5 , 57],
      [28 , 24 , 56 , 144   , 57 ,  132  ,  52  , 126  , 50 , 151.5 , 60],
      [30 , 26 , 58 , 151   , 59 ,  139  ,  54  , 133  , 52 , 158.5 , 62],
    ]

    make_size_chart(size_set)
  end

  def size_chart_2014
    size_set = [
      [ 4 ,  0 , 32 ,  81 , 32 ,  60 , 24 ,  91 , 36],
      [ 6 ,  2 , 34 ,  84 , 33 ,  63 , 25 ,  92 , 36],
      [ 8 ,  4 , 36 ,  87 , 34 ,  66 , 26 ,  95 , 37],
      [10 ,  6 , 38 ,  92 , 36 ,  71 , 28 , 100 , 39],
      [12 ,  8 , 40 ,  97 , 38 ,  78 , 31 , 105 , 41],
      [14 , 10 , 42 , 102 , 40 ,  85 , 33 , 110 , 43],
      [16 , 12 , 44 , 107 , 42 ,  92 , 36 , 115 , 45],
      [18 , 14 , 46 , 112 , 44 ,  99 , 39 , 120 , 47],
      [20 , 16 , 48 , 117 , 46 , 106 , 42 , 125 , 49],
      [22 , 18 , 50 , 122 , 48 , 113 , 44 , 130 , 51],
      [24 , 20 , 52 , 128 , 50 , 120 , 47 , 136 , 54],
      [26 , 22 , 54 , 134 , 53 , 127 , 50 , 142 , 56],
    ]

    make_size_chart(size_set)
  end

  private def make_size_chart(size_set)
    size_headings = [
      "Size Aus/UK",
      "Size US",
      "Bust cm",
      "Bust Inches",
      "Underbust cm",
      "Underbust Inches",
      "Waist cm",
      "Waist Inches",
      "Hip cm",
      "Hip Inches",
    ]

    size_set.collect { |size_values| size_headings.zip(size_values).to_h }
  end

  SIZE_CHART_2014 = self.size_chart_2014.freeze
  SIZE_CHART_2015 = self.size_chart_2015.freeze
  SIZE_CHART_2016 = self.size_chart_2016.freeze
  SIZE_CHART_2016_v2 = self.size_chart_2016_v2.freeze
  DEFAULT_CHART = SIZE_CHART_2016_v2

  CHARTS = {
    '2014' => SIZE_CHART_2014,
    '2015' => SIZE_CHART_2015,
    '2016' => SIZE_CHART_2016,
    '2016_v2' => SIZE_CHART_2016_v2,
  }

  def self.default_chart_name
    self::CHARTS.keys.last
  end
end
