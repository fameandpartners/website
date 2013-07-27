Spree::Taxon.class_eval do
  has_one :banner,
    dependent: :destroy,
    class_name: 'Spree::TaxonBanner',
    foreign_key: :spree_taxon_id

  accepts_nested_attributes_for :banner
  #accepts_nested_attributes_for :tasks, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
end
