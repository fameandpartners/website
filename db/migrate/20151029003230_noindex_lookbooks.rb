class NoindexLookbooks < ActiveRecord::Migration
  def up
    lookbooks = Revolution::Page.where("path LIKE '/lookbook%'").all
    lookbooks.each do |lookbook|
      lookbook.noindex = true
      lookbook.nofollow = false
      lookbook.save!
    end
  end

  def down
    #noop
  end
end
