class CreateLaBelleEpoqueLookbook < ActiveRecord::Migration
  def up
    Revolution::Page.where(path: '/lookbook/pass-the-mimosa').first.destroy

    page = Revolution::Page.create!(
      :path => '/lookbook/la-belle-epoque',
      :template_path => '/lookbook/show',
      :variables => {:image_count=>5, :lookbook => true, :limit => 24}
    )
    page.translations.create!(:locale => 'en-US', :title => 'La Belle Epoque', :meta_description => 'La Belle Epoque', :heading => 'La Belle Epoque')
    page.variables[:pids] = "1019-watercolour-camo,1026-olive-shimmer,1011-peach,1021-white,1025-pale-pink,1012-white,1017-watercolour-camo,1018-black,1022-cobalt-crush-floral,957-blush,983-ivory,954-navy,1024-renta-watercolour,1012-navy,1015-cobalt-crush-floral,1016-ice-blue,1020-cobalt-crush-floral"
    page.save!
    page.publish!

    taxon = Spree::Taxon.where(name: 'PASS THE MIMOSA').first
    if taxon.present?
      taxon.name = 'La Belle Epoque'
      taxon.permalink = 'edits/la-belle-epoque'
      taxon.save!
    end

  end

  def down
  end
end
