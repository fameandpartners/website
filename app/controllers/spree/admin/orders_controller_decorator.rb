Spree::Admin::OrdersController.class_eval do
  respond_to :csv, only: :index
end