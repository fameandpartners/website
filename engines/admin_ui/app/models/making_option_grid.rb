require 'datagrid'

class MakingOptionGrid
  include ::Datagrid

  scope do
    MakingOption.order('id desc')
  end

  filter(:code, :string) { |value| where("code ilike ?", "%#{value}%") }
  filter(:name, :string) { |value| where("name ilike ?", "%#{value}%") }

  column :id do |cv|
    format(cv.id) do
      link_to(cv.id, edit_content_making_option_path(cv))
    end
  end

  column :code
  column :name
  column :description
  column :delivery_time_days
end
