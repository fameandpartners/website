require 'datagrid'

class FabricGrid
  include ::Datagrid

  scope do
    Fabric.order('created_at desc')
  end

  filter(:presentation, :string) { |value| where("presentation ilike ?", "%#{value}%") }
  filter(:name, :string) { |value| where("name ilike ?", "%#{value}%") }

  column :id do |cv|
    format(cv.id) do
      link_to(cv.id, edit_fabric_path(cv))
    end
  end

  column :name
  column :presentation
end
