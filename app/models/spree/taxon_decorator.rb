require_dependency 'spree/taxonomy_decorator'

Spree::Taxon.class_eval do
  include Concerns::Publishable

  DELIVERY_PERIODS =
    [
      '5 - 7 business days',
      '7 - 10 business days',
      '12 - 15 business days',
      '2 - 3 weeks',
      '3 - 4 weeks',
      '3 - 6 weeks',
      '4 - 6 weeks',
      '6 weeks',
      '6 - 10 weeks'
    ]

  attr_accessible :delivery_period

  has_one :banner,
    dependent: :destroy,
    class_name: 'Spree::TaxonBanner',
    foreign_key: :spree_taxon_id

  validates_inclusion_of :delivery_period, in: DELIVERY_PERIODS

  accepts_nested_attributes_for :banner

  class << self
    def find_child_taxons_by_permalink(permalink)
      where('permalink LIKE ?', "%/#{permalink.downcase}").first
    end

    def from_taxonomy(taxonomy_name)
      includes(:taxonomy).where(spree_taxonomies: { name: taxonomy_name })
    end

    ::Spree::Taxonomy::CURRENT.each do |taxonomy_name|
      define_method("from_#{taxonomy_name.downcase}_taxonomy") do
        from_taxonomy(taxonomy_name)
      end
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
