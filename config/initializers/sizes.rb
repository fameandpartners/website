sizes = []
# index      0    1    2    3    4      5   6      7    8
#            US   AU   UK   Bust        Waist      Hip
#                           cm   in     cm  in     cm   in
sizes << %w( 0    4    4    77   30.3   56  22     85   33.5 )
sizes << %w( 2    6    6    82   32.3   61  24     90   35.4 )
sizes << %w( 4    8    8    87   34.3   66  26     95   37.4 )
sizes << %w( 6    10   10   92   36.2   71  28     100  39.4 )
sizes << %w( 8    12   12   97   38.2   76  30     105  41.3 )
sizes << %w( 10   14   14   102  40.2   81  31.9   110  43.3 )
sizes << %w( 12   16   16   107  42.1   86  33.9   115  45.3 )

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