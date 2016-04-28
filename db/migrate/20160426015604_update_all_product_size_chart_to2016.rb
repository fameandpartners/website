class UpdateAllProductSizeChartTo2016 < ActiveRecord::Migration
  def up
    Spree::Product.all.each do |p|
      p.size_chart = "2016"
      p.save!
    end
  end

  def down
    #NOOP
  end
end
