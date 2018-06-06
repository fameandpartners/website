class RemoveHolidayEditPage < ActiveRecord::Migration
  def up
    Revolution::Page.where(:path => '/the-holiday-edit').delete_all
  end
end
