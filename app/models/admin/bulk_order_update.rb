module Admin
  class BulkOrderUpdate < ActiveRecord::Base
    attr_accessible :user, :filename

    has_many :line_item_updates, :class_name => 'LineItemUpdate', autosave: true
  end
end
