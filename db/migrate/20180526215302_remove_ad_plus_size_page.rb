class RemoveAdPlusSizePage < ActiveRecord::Migration
  def up
    Revolution::Page.where(path: "/ad-plus-size").delete_all
  end
end
