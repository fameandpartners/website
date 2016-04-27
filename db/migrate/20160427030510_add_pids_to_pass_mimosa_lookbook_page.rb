class AddPidsToPassMimosaLookbookPage < ActiveRecord::Migration
  def up
    page = Revolution::Page.where(path: '/lookbook/pass-the-mimosa').first
    page.variables[:pids] = "1019-watercolour-camo,1026-olive-shimmer,1011-peach,1021-white,1025-pale-pink,1012-white,1017-watercolour-camo,1018-black,1022-cobalt-crush-floral,957-blush,983-ivory,954-navy,1024-renta-watercolour,1012-navy,1015-cobalt-crush-floral,1016-ice-blue,1020-cobalt-crush-floral"
    page.save!
  end
  def down
    #noop
  end
end
