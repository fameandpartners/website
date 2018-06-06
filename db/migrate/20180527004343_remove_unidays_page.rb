class RemoveUnidaysPage < ActiveRecord::Migration
  def up
    Revolution::Page.where(:path => '/unidays').delete_all
  end
end
