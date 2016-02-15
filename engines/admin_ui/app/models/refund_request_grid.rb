require 'datagrid'

class RefundRequestGrid
  include Datagrid

  scope do
    RefundRequest
  end

  filter(:custom1, :dynamic)
  filter(:custom2, :dynamic)

  filter :order_number
  filter :payment_ref
  filter(:currency, :enum, :select => RefundRequest.pluck(:currency).uniq)

  filter :payment_amount
  filter(:acceptance_status, :enum, :select => RefundRequest.pluck(:acceptance_status).uniq)
  # filter :requested_refund_amount
  # filter :payment_created_at
  filter :customer_name
  filter :customer_email
  filter :refund_ref
  filter(:refund_currency, :enum, :select => RefundRequest.pluck(:refund_currency).uniq)
  # filter :refund_success
  filter :refund_amount
  filter :refund_created_at
  filter(:refund_status_message, :enum, :select => RefundRequest.pluck(:refund_status_message).uniq)

  # column :payment
  # column :order
  column :order_number
  column :payment_ref
  column :currency
  column :payment_amount
  column :acceptance_status
  column :requested_refund_amount
  column :payment_created_at
  column :customer_name
  column :customer_email
  column :refund_ref
  column :refund_currency
  # column :refund_success
  column :refund_amount
  column :refund_created_at
  # column :refund_error_message
  column :refund_status_message
  # column :public_key
  # column :secret_key
  # column :api_url
end
