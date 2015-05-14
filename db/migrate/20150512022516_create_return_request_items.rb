class CreateReturnRequestItems < ActiveRecord::Migration
  def change
    create_table :return_request_items do |t|
      t.references  :order_return_request
      t.references  :line_item
      t.integer     :quantity
      t.text        :action
      t.text        :reason_category
      t.text        :reason
      t.timestamps
    end
  end
end
