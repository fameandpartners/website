class TagNewThisWeek < ActiveRecord::Migration
  def change
    new_this_week_taxon_id = Spree::Taxon.where(name: 'New This Week').first.id
    dress_names = ["Paradiso","Preacher","Regalia","Spoken For Two Piece","Said It All Two Piece","Prism","Mystic Goddess","Eyes On You Two Piece","Dark Storm","Metallic Spirit","Jascinta","Midnight Song","Shimmer Vixen","Sorrento","Feathered Lover","One And Only Two Piece","Matrix","Patrice","Halle","Krissa Two Piece","Artful Mind Two Piece","Fire Eyes","Wisdom Two Piece","Neo Velvet Two Piece","Jupiter Two Piece","Midnight Eyes Two Piece","Art Soul","Retrogade","Velvet Valour","Black Widow","Mercury Rising","Belgravia Velvet Two Piece","Light Field","Velvet Rebel Three Piece","Beyond Desire","Piranha"]
    dress_names.each do |n|
      p = Spree::Product.where(name: n).first
      sql = "INSERT INTO \"spree_products_taxons\" (\"product_id\", \"taxon_id\") VALUES (#{p.id}, #{new_this_week_taxon_id})"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end

