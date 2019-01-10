class CreateCustomisationGroup < ActiveRecord::Migration
  def change
    create_table :customisation_groups do |t|
      t.string :name
      t.string :title
      t.string :slug
      t.string :selection_title
      t.string :change_button_text
      t.string :section_title
      t.string :selection_type
      t.string :preview_type
    
      t.timestamps
    end

    add_column :customisation_values, :customisation_group_id, :integer


    legacy_one = CustomisationGroup.create!(
      name: 'Customizations (Select one)',
      title: 'Customizations',
      slug: 'customize',
      selection_title: "Customize your dress",
      change_button_text: "Change",
      preview_type: :cad,
      selection_type: :OptionalOne,
      section_title: "Select your customizations"
    )

    legacy_multiple = CustomisationGroup.create!(
      name: 'Customizations (Select many)',
      title: 'Customizations',
      slug: 'customize',
      selection_title: "Customize your dress",
      change_button_text: "Change",
      preview_type: :cad,
      selection_type: :OptionalMultiple,
      section_title: "Select your customizations"
    )

    length = CustomisationGroup.create!(
      name: 'Length',
      title: 'Length',
      slug: 'length',
      selection_title: "Change your length",
      change_button_text: "Change",
      preview_type: :cad,
      selection_type: :RequiredOne,
      section_title: "Select your length"
    )

    top = CustomisationGroup.create!(
      name: 'Top',
      title: 'Top',
      slug: 'top',
      selection_title: "Change your top",
      change_button_text: "Change",
      preview_type: :cad,
      selection_type: :RequiredOne,
      section_title: "Select your top"
    )

    skirt = CustomisationGroup.create!(
      name: 'Skirt',
      title: 'Skirt',
      slug: 'skirt',
      selection_title: "Change your Skirt",
      change_button_text: "Change",
      preview_type: :cad,
      selection_type: :RequiredOne,
      section_title: "Select your skirt"
    )

    Spree::Product.includes(:customisation_values).each do |product|
      if product.customisation_values.length == 3 
        product.customisation_values.update_all(customisation_group_id: legacy_one.id)
      elsif product.customisation_values.length == 4
        product.customisation_values.update_all(customisation_group_id: legacy_multiple.id)
      end
    end
  end
end