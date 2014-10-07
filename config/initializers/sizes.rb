sizes = []
# index      0     1     2     3    4     5   6      7    8
#            US    AU    UK    Bust       Waist      Hip
#                              cm   in    cm   in    cm   in
sizes << %w( 0     4     4     81   32    60   24    91   36 )
sizes << %w( 2     6     6     84   33    63   25    92   36 )
sizes << %w( 4     8     8     87   34    66   26    95   37 )
sizes << %w( 6     10    10    92   36    71   28    100  39 )
sizes << %w( 8     12    12    97   38    78   31    105  41 )
sizes << %w( 10    14    14    102  40    85   33    110  43 )
sizes << %w( 12    16    16    107  42    92   36    115  45 )
sizes << %w( 14    18    18    112  44    99   39    120  47 )
sizes << %w( 16    20    20    117  46    106  42    125  49 )
sizes << %w( 18    22    22    122  48    113  44    130  51 )
sizes << %w( 20    24    24    128  50    120  47    136  54 )
sizes << %w( 22    26    26    134  53    127  50    142  56 )

SIZE_ATTRIBUTES = sizes.map do |attrs|
  {
    name: { us: attrs[0], au: attrs[1], uk: attrs[2] },
    attributes: {
      bust:  { cm: attrs[3], in: attrs[4] },
      waist: { cm: attrs[5], in: attrs[6] },
      hip:   { cm: attrs[7], in: attrs[8] }
    }
  }
end

def SIZE_ATTRIBUTES.find_by_us_name(us_name)
  SIZE_ATTRIBUTES.detect do |attributes|
    attributes[:name][:us].eql?(us_name.to_s)
  end
end

def SIZE_ATTRIBUTES.find_by_au_name(au_name)
  SIZE_ATTRIBUTES.detect do |attributes|
    attributes[:name][:au].eql?(au_name.to_s)
  end
end