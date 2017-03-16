require 'datagrid'

class CustomisationValuesGrid
  include ::Datagrid

  scope do
    CustomisationValue.order('created_at desc')
  end

  filter(:presentation, :string) { |value| where("presentation ilike ?", "%#{value}%") }
  filter(:name, :string) { |value| where("name ilike ?", "%#{value}%") }
  filter :customisation_type, :enum, select: CustomisationValue::AVAILABLE_CUSTOMISATION_TYPES

  column :id do |cv|
    format(cv.id) do
      link_to(cv.id, edit_customisation_customisation_value_path(cv))
    end
  end

  column :name
  column :presentation
  column :price
  column :customisation_type

  column :remove?, html: true do |cv|
    button_to('Remove', admin_ui.customisation_customisation_value_path(cv), action: 'destroy', method: 'delete', class: 'btn btn-danger', data: { confirm: 'Are you sure?' })
  end
end
