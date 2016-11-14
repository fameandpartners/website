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
      payload = "aUVDAmAujHWvAxkjmbcrFUvgfcWKAXG2kILhei+pDcR6IHXmr4E6QvaI4fauXMuaTTBoNv3dbIL8XcwRMv4fvAux96ZJFz54/IQhQVlsWuw+yfgM0BDgHKTS6Xze2ZAbxj+goL2i3aNEAmQMwxsu8bpRQDiYghIU9/Dn5Vuunkj8LjxhIozZI9gQ+dYZ5HAzawfxheR7xSewd2+fsWk5GzKqttXLmkUevQDWZGGe+/dTQth2xrZZpZcXP8i88Bb5nuSuhVj4CQEbfIBSccDOsLJpxN71mwdw6wvQAbiasDWEZbYtI5AL/XXYjalWo6JN1nh5JwteKFpCmROAyL8lOUW831gj6FCp6W1VrOKj+ze4msNxg5XU8aUWX9ZP+F/ar8+mFHh5sMNCKR4v166gxsqapxk="

      order_hash = described_class.decode(payload)
      
      expect(order_hash).to include({
        "orderid" => "R103182841",
        "totalamount" => "0.0",
        "customer_email" => "elton.stewart+71@gmail.com",
        "first_name" => "Elton",
        "surname" => "Stewart",
        "customer_id" => 18,
        "postcode" => "2010",
        "state" => "NSW",
        "country" => "AUSTRALIA",
        "firstname" => "Elton",
        "state_text" => "NSW",
        "country_iso_name" => "AUSTRALIA"
      })
    end

    it 'should decode payload w/o customer data' do
      payload = "aUVDAgPscCdRuNIodZgMjxnsNJ1CcWKT4fxMGl7mA/E5qJ5a7VGd8szLAoXJXtZchR1g4Xt1I+fPTTVfnHbjnPoBQ3njywrb14qb7v0ug3ncD18lUjYiBGO1VP2/nPPvRtK27GsCmesb+LVd0BhyV47evytklt0g1epZc6l8PqN99CxvokW7bezsl4h5NAS2fnNt7kaGoFlPVCX9cEiYsC1Dk1AWKNm4rhAoNltAu0n/LHQubLbp1lV/QzRBvFc7+i7Edg=="

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
