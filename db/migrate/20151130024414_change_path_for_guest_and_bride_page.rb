class ChangePathForGuestAndBridePage < ActiveRecord::Migration
  def up
    if (page = Revolution::Page.where(path: '/guest').first)
      page.path    = '/fameweddings/guest'
      page.noindex = true
      page.save(validate: false)
    end

    if (page = Revolution::Page.where(path: '/brides').first)
      page.path    = '/fameweddings/bride'
      page.noindex = true
      page.save(validate: false)
    end
  end

  def down
    if (page = Revolution::Page.where(path: '/fameweddings/guest').first)
      page.path    = '/guest'
      page.noindex = true
      page.save(validate: false)
    end

    if (page = Revolution::Page.where(path: '/fameweddings/bride').first)
      page.path    = '/brides'
      page.noindex = true
      page.save(validate: false)
    end
  end
end
