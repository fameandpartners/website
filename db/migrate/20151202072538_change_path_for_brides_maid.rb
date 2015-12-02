class ChangePathForBridesMaid < ActiveRecord::Migration
  def up
    if (page = Revolution::Page.where(path: '/famingtonway').first)
      page.path    = '/fameweddings/bridesmaid'
      page.noindex = true
      page.save(validate: false)
    end
  end
end
