Spree::Taxon.class_eval do
  has_one :banner,
    dependent: :destroy,
    class_name: 'Spree::TaxonBanner',
    foreign_key: :spree_taxon_id

  accepts_nested_attributes_for :banner

  def taxons_with_banner_info
    %w{edits collection style event}
  end

  def have_banner_info?
    taxons_with_banner_info.include?(self.root.permalink)
  end

  def banner_position
    @banner_position ||= (taxons_with_banner_info.index(self.root.permalink) || taxons_with_banner_info.size)
  end

  def base_permalink
    self.permalink.to_s.split('/').last
  end
end
