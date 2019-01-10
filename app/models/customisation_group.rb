class CustomisationGroup < ActiveRecord::Base
  has_many :customisation_values

  attr_accessible :name, :title, :slug, :selection_title, :change_button_text, :preview_type, :selection_type, :section_title
end