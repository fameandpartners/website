class UpdateAllProductSizeChartTo2016V2 < ActiveRecord::Migration
  def change
    Spree::Product.active.update_all(size_chart: '2016_v2')
  end
end
