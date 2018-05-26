class RemoveAdPlusSizePage < ActiveRecord::Migration
  def up
    Revolution::Page.where(path: "/ad-plus-size").destroy!
  end
end
