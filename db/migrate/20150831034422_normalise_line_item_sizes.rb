class NormaliseLineItemSizes < ActiveRecord::Migration
  def up
    normaliser = LineItemSizeNormalisation::Normaliser.new
    normaliser.build_normalisations
  end

  def down
    LineItemSizeNormalisation.delete_all
  end
end
