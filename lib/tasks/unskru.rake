namespace :data do
  desc 'fark'
  task :unskru => :environment do
    # upcs = [
    #   43468,
    #   42610,
    #   50270,
    #   53020,
    #   41802,
    #   50534,
    #   42618,
    #   48127,
    #   41065,
    #   52221,
    #   52272,
    #   50199,
    #   52311,
    #   50275,
    #   51239,
    #   52201,
    #   51757,
    #   45289,
    #   50696,
    #   50255,
    #   41390,
    #   23029,
    #   46340,
    #   48350,
    #   42355,
    #   55981,
    #   47047,
    #   47145,
    #   40892,
    #   41266,
    #   54228,
    #   40061,
    #   41116,
    #   52161,
    #   49095,
    #   46553,
    #   46554,
    #   46552,
    #   49731,
    #   48428,
    #   51113,
    #   40194,
    #   40505,
    #   45052,
    #   50614,
    #   52536,
    #   52535,
    #   57466,
    #   46413,
    #   51736,
    #   51654,
    #   52279,
    #   51415,
    #   50084,
    #   47520,
    #   45963,
    #   46413,
    #   42869,
    #   53026,
    #   58375,
    #   51997,
    #   52655,
    #   57464,
    #   55264,
    #   50275,
    #   52949,
    #   52948,
    #   52946,
    #   46795,
    #   47108,
    #   57398,
    #   57397,
    #   55086,
    #   52463,
    #   39472,
    #   47299,
    #   54395,
    #   40544
    # ]

    fark = Time.parse('18-9-2017')
    upcs = GlobalSku.where("created_at > ?", fark)

    upc_dups = GlobalSku.where("created_at > ?", fark).map do |upc|
      gsku = GlobalSku.find upc
      upc_ary = gsku.sku.chars
      upc_ary.pop
      # upc_ary << '%'

      # skus = GlobalSku.where("sku = ?", upc_ary.join(''))

      # {upc => skus.map(&:id)}

      sku = GlobalSku.find_by_sku(upc_ary.join(''))

      {upc.sku => sku&.sku}

    end

    # upc_dups = upc_dups.select{|x| x.values[0].count > 1}
    upc_dups = upc_dups.select{|x| x.values[0]}
    # lala = upc_dups.map do |duper|
    #   duper.last[0].map(&:sku)
    # end

  end
end
