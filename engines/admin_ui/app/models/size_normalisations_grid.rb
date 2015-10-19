require 'datagrid'

class SizeNormalisationsGrid
  include Datagrid

  scope do
    LineItemSizeNormalisation.fully_hydrated.joins(:spree_order).order('spree_orders.created_at DESC')
  end

  filter(:state, :enum,
     select: -> { LineItemSizeNormalisation.pluck(:state).uniq }
  )
  filter(:order_created_at, :datetime)
  filter(:id, :string)
  filter(:custom1, :dynamic)
  filter(:custom2, :dynamic)


  column :id
  column :line_item_id, html: true do |normalisation|
    normalisation.line_item.try(:variant).try(:sku) || normalisation.line_item_id
  end

  column :line_item_personalization_id, header: 'Personalisation'

  column :order_created_at
  column :order_number, html: true do |normalisation|
    link_to normalisation.order_number, spree.admin_order_path(id: normalisation.order_number)
  end

  column :currency
  column :site_version
  column :old_size_value
  column :old_size_id, html: true do |normalisation|
    normalisation.old_size.try(:name) || '?'
  end
  column :old_variant_id, html: true do |normalisation|
    normalisation.old_variant.try(:sku) || normalisation.old_variant_id
  end

  column :new_size_value
  column :new_size_id, html: true do |normalisation|
    normalisation.new_size.try(:name) || '?'
  end

  column :new_variant_id, html: true do |normalisation|
    normalisation.new_variant.try(:sku) || normalisation.new_variant_id
  end

  column :messages
  column :state
  column :processed_at
  column :created_at
  column :updated_at
end
