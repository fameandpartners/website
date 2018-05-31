class RemoveFameweddingsPages < ActiveRecord::Migration
  def up
    Revolution::Page.where(:path => '/fameweddings/bridesmaid').delete_all
    Revolution::Page.where(:path => '/fameweddings/bride').delete_all
    Revolution::Page.where(:path => '/fameweddings/guest').delete_all
  end
end
