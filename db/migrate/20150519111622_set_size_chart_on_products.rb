class SetSizeChartOnProducts < ActiveRecord::Migration

  def up
    prods = Spree::Product.find(Spree::Variant.where('lower(sku) in (?)', skus).pluck(:product_id).uniq)
    prods.map { |p| p.size_chart = '2015' }
    prods.map &:save

    prods.map {|p|
      puts "#{p.name} - #{p.size_chart}"
    }
  end

  def down
  end

  private
  def skus
    %w[
    4B254
    4B110
    4B289
    4B302
    4B274
    4B271
    4B257
    4B255
    4B303
    4B301
    4B263
    4B054
    4B266
    4B297
    4B291
    4B268
    4B250
    4B253
    4B141
    13054
    1310023
    4B341
    4B342
    4B343
    4B344
    4B346
    4B349
    4B350
    4B351
    4B352
    4B356
    4B363
    4B376
    4B377
    4B378
    4B337
    4B380
    4B383
    4B384
    4B390
    4B315
    4B327
    4B371
    4B379
    4B382
    4B386
    4B387
    4B388].map &:downcase
  end


end
