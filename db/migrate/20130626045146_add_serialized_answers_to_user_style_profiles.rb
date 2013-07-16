class AddSerializedAnswersToUserStyleProfiles < ActiveRecord::Migration
  def change
    add_column :user_style_profiles, :serialized_answers, :text
  end
end
