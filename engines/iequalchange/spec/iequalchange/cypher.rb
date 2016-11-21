require 'spec_helper'

RSpec.describe Iequalchange::Cypher do
  let(:order) { FactoryGirl.create(:spree_order) }

  context '#with order' do
    it 'should encode and decode payload' do
      iec_hash = described_class.new(order).encode
      expect(iec_hash.keys).to contain_exactly(:id, :src, :url, :payload)

      order_hash = described_class.decode(iec_hash.fetch(:payload))
      expect(order_hash.fetch('orderid')).to eq(order.number)
      expect(order_hash.fetch('totalamount')).to eq(order.item_total.to_s)
    end

    it 'should decode payload w/ customer data' do
      payload = "aUVDAtt/hTZ+b08MlIU6cFtMByzA/UxMYRMFrfVb6607l6dt2DxD/niCiMEHkAGnFj//FFcDQ43D5g6OIlmZCZf/JC0FhpbqQyBLGe+wSMqctpdcJv1RMXRJkXOOFoZBCEjZtSdzu3yKZIYsGZiZCg9KNv0URg4tPFjOsfU/s85NeW31+B0SEMIHkOLNbAVVZXv0c1wcohstILPnvHneWImdW8P0sOzGWwnkkSDdIA4EFPWqJ3Brobq5XjXuLNnrCyuj+klp9ewATzSgtBN4AsJTSFr2n3yq6eO6r8sJQw0XwyBxwLk9jzluaKnMffY8Xbi52w=="

      order_hash = described_class.decode(payload)
      
      expect(order_hash).to include({
        "orderid"        => "R655600874",
        "totalamount"    => "299.0",
        "customer_email" => "anonymous_user@fameandpartners.com",
        "first_name"     => "Lorem",
        "surname"        => "Ipsum",
        "customer_id"    => 71716,
        "postcode"       => "12345",
        "state"          => "WA",
        "country"        => "UNITED STATES"
      })
    end

    it 'should decode payload w/o customer data' do
      payload = "aUVDAtEaqeQenJ4Yh6H0QH6GAbjzMZVT7gZqGaumrDqppCky/uXd0p3PfAqDv49oApxrdrw2fRN2aTnfWwg42DJmETVb+mHExBcIdxitRn1fXWvurWmMfU861FU+aS9yUpuOVJ58n3OxZ7P6co0ED1LJKhZO349Znv7sJaf8+GsEPGjMAjg5/llzRRezxcKXi1TB4C3JjSvgCRcnY7CGho/AyqjY2sOUJe1MeV8wUDLjGdW8g1mnxcJkhxTmQiY6kiX2iQ=="

      order_hash = described_class.decode(payload)
      
      expect(order_hash).to include({
        "orderid" => "R811862231",
        "totalamount" => "0.0",
        "customer_email" => nil,
        "first_name" => nil,
        "surname" => nil,
        "customer_id" => "Guest Checkout",
        "postcode" => nil,
        "state" => nil,
        "country" => nil
      })
    end

  end
end
