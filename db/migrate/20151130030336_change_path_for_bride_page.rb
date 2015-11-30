class ChangePathForBridePage < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: "/brides").first
    page.path = "/fameweddings/bride"
    page.save(validate: false)
  end
end
