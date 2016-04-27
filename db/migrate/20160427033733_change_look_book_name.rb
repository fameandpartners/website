class ChangeLookBookName < ActiveRecord::Migration
  def up
    p = Revolution::Page.where(path: "/lookbook/pass-the-mimosa").first
    p.path = "/lookbook/la-belle-epoque"
    p.save
  end

  def down
    #noop
  end
end
