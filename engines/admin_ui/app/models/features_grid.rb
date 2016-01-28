require 'datagrid'

class FeatureState < Struct.new(:feature, :active)
  def self.all
    Features.available_features.map {|feature|
      new(feature, Features.active?(feature))
    }
  end

  def state
    active ? 'Enabled' : 'Disabled'
  end

  def transition_state
    active ? 'Disable' : 'Enable'
  end
end

class FeaturesGrid
  include Datagrid

  self.default_column_options = {order: false}

  scope do
    FeatureState.all
  end

  column :feature
  column :state
  column :active? do |feature|
    format(feature.active) do
      class_name = feature.active ? 'thumbs-o-up' : 'exclamation text-warning'
      content_tag(:i, '', class: "fa fa-#{class_name}  fa-lg")
    end
  end

  column :transition_state, header: 'Action' do |feature|
    format(feature.transition_state) do
      path = feature.active ? disable_backend_features_path(feature: feature.feature) : enable_backend_features_path(feature: feature.feature)

      button_class = feature.active ? 'danger' : 'primary'

      link_to feature.transition_state, path,  class: "btn btn-sm btn-#{button_class}"
    end
  end
end

