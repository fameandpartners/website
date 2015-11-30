class ChangePathForGuestPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: "/guest").first
    page.path = "/fameweddings/guest"
    page.save(validate: false)
  end
end
