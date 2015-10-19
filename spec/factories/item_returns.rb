# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_return do
    order_number "MyString"
    line_item_id 1
    qty 1
    requested_action "MyString"
    requested_at "2015-06-23 13:49:32"
    reason_category "MyString"
    reason_sub_category "MyString"
    request_notes "MyText"
    contact_email "MyString"
    comments "MyText"
    product_name "MyString"
    product_style_number "MyString"
    product_colour "MyString"
    product_size "MyString"
    product_customisations false
    received_on "2015-06-23"
    received_location "MyString"
    order_payment_method "MyString"
    order_paid_amount 1
    order_paid_currency "MyString"
    order_payment_ref "MyString"
    refund_status "MyString"
    refund_ref "MyString"
    refund_method "MyString"
    refund_amount 1
    refunded_at "2015-06-23 13:49:32"
  end
end
