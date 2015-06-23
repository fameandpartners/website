Spree::Taxon.class_eval do
  attr_accessible :published_at

  has_one :banner,
    dependent: :destroy,
    class_name: 'Spree::TaxonBanner',
    foreign_key: :spree_taxon_id

  scope :published, -> { where('published_at <= ?', Time.zone.now) }

  accepts_nested_attributes_for :banner

  class << self
    def find_child_taxons_by_permalink(permalink)
      where('permalink LIKE ?', "%/#{permalink}").first
    end
  end

  def seo_title
    return meta_title if !meta_title.blank?
    banner.nil? ? name : banner.title
  end

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
