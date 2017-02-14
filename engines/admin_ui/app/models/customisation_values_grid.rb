require 'datagrid'

class CustomisationValuesGrid
  include ::Datagrid

  scope do
    CustomisationValue.scoped
  end

  column :id do |cv|
    format(cv.id) do
      link_to(cv.id, edit_customisation_customisation_value_path(cv))
    end
  end

  column :name
  column :presentation
  column :price
  column :customisation_type

  column :remove? do |cv|
    format(cv.id) do
      button_to('Remove', customisation_customisation_value_path(cv), action: 'destroy', method: 'delete', class: 'btn btn-danger', data: { confirm: 'Are you sure?' })
    end
  end
end
