class RemoveBridalDressesPage < ActiveRecord::Migration
  def up
    Revolution::Page.where(:path => '/bridal-dresses').delete_all
  end
end
