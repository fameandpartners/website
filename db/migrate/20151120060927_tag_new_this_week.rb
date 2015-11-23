class TagNewThisWeek < ActiveRecord::Migration
  def up
    if new_this_week_taxon
      dresses.find_each { |product| product.taxons << new_this_week_taxon if !product.taxons.any?{|t| t.name == 'New This Week'}}
    end
  end

  private

  def new_this_week_taxon
    @taxon ||= Spree::Taxon.where(name: 'New This Week').first
  end

  def dresses
    dress_names = ["Paradiso","Preacher","Regalia","Spoken For Two Piece","Said It All Two Piece","Prism","Mystic Goddess","Eyes On You Two Piece","Dark Storm","Metallic Spirit","Jascinta","Midnight Song","Shimmer Vixen","Sorrento","Feathered Lover","One And Only Two Piece","Matrix","Patrice","Halle","Krissa Two Piece","Artful Mind Two Piece","Fire Eyes","Wisdom Two Piece","Neo Velvet Two Piece","Jupiter Two Piece","Midnight Eyes Two Piece","Art Soul","Retrogade","Velvet Valour","Black Widow","Mercury Rising","Belgravia Velvet Two Piece","Light Field","Velvet Rebel Three Piece","Beyond Desire","Piranha"]
    @dresses ||= Spree::Product.where(name: dress_names)
  end
end

