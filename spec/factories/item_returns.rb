# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_return do
    sequence(:uuid) { SecureRandom.uuid }
    order_number "MyString"
    sequence(:line_item_id)
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
    bergen_asn_number "WHRTN915384"

    trait :bergen_rejected do
      bergen_actual_quantity 0
      bergen_damaged_quantity 1
    end

    trait :bergen_accepted do
      bergen_actual_quantity 1
      bergen_damaged_quantity 0
    end
  end
end
