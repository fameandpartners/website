module SizeChart
  module_function

  def chart(chart_name)
    CHARTS.fetch(chart_name) { DEFAULT_CHART }
  end

  def size_chart_2015
    size_set = [
      [ 4 ,  0 , 32 ,  78   , 31 ,  66   ,  26  , 60   , 24 ,  84   , 35],
      [ 6 ,  2 , 34 ,  80.5 , 32 ,  68.5 ,  27  , 62.5 , 25 ,  86.5 , 36],
      [ 8 ,  4 , 36 ,  83   , 33 ,  71   ,  30  , 65   , 26 ,  89   , 37],
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
      "Size DE",
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
  DEFAULT_CHART   = SIZE_CHART_2014

  CHARTS = {
    '2014' => SIZE_CHART_2014,
    '2015' => SIZE_CHART_2015
  }
end
