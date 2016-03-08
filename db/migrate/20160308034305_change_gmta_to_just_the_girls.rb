class ChangeGmtaToJustTheGirls < ActiveRecord::Migration
  def up
    tx = Spree::Taxon.where(name: "Great Minds").first
    if tx.present?
      tx.name      = "Just The Girls"
      tx.permalink = "edits/just-the-girls"
      tx.save!
    end

    if Revolution::Page.where(path: "/lookbook/just-the-girls").first.nil?
      page = Revolution::Page.create!(
        :path => '/lookbook/just-the-girls',
        :template_path => '/lookbook/show.html.slim',
        :variables => {:image_count=>6, :lookbook => true, :limit => 24}
      )
      page.translations.create!(:locale => 'en-US', :title => 'Just The Girls', :meta_description => 'Just The Girls', :heading => 'Just The Girls')
      page.publish!
    end
  end

  def down
    tx = Spree::Taxon.where(name: "Just The Girls").first
    if tx.present?
      tx.name      = "Great Minds"
      tx.permalink = "edits/great-minds"
      tx.save!
    end

    Revolution::Page.where(:path => '/lookbook/just-the-girls').delete_all
  end
end
