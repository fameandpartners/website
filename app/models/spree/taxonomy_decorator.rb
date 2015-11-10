Spree::Taxonomy.class_eval do
  # TODO: This shouldn't be hardcoded here. It would be interesting if taxonomies had the same
  # publishable concern as taxons, but it lacks an admin interface
  ::Spree::Taxonomy::CURRENT = %w(Event Range Style Edits)
  ::Spree::Taxonomy::OUTERWEAR_NAME = 'Outerwear'
end
