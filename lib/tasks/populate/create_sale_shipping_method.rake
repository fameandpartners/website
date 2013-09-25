namespace "db" do
  namespace "populate" do
    desc "create 11.95 shipping method"
    task sale_shipping_method: :environment do
      method = Spree::ShippingMethod.where(name: 'sale_11_95').first_or_initialize
      method.zone = Spree::Zone.first
      method.assign_attributes({
        display_on: 'back_end',
        calculator_type: 'Spree::Calculator::FlatRate'
      })
      method.calculator.assign_attributes({
        preferred_amount: 11.95,
        preferred_currency: 'AUD'
      })
      method.save
    end
  end
end