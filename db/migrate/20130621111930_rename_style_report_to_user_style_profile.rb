class RenameStyleReportToUserStyleProfile < ActiveRecord::Migration
  def change
    rename_table :style_reports, :user_style_profiles
  end
end
