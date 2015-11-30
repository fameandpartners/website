class ChangePathForBridePage < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: "/brides").first
    if page.present?
      page.path = "/fameweddings/bride"
      page.save(validate: false)
    end
  end
end
