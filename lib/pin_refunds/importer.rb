PinPayment::Charge.send(:include, PinRefunds::ChargeFindRefunds)

module PinRefunds
  class Importer < Importers::FileImporter

    attr_reader :requests

    def column_matchers
      {
        "order_number"      => :order_number,
        "Payment ID"        => :payment_ref,
        "Date"              => :payment_created_at,
        "Full Order Amount" => :payment_amount,
        "Currency"          => :currency,
        "customer_name"     => :customer_name,
        "contact_email"     => :customer_email,
        "acceptance_status" => :acceptance_status,
        "refund_status"     => :refund_status_message,
        "refund_ref"        => :refund_ref,
        "refund_amount"     => :refund_amount,
        "refunded_at"       => :refund_created_at,
      }
    end

    def import
      info "Start"
      build_refund_requests
      fetch_spree_objects
      find_correct_gateway_and_charge
      save_all
    end

    def build_refund_requests
      info "Reading File"
      csv = CSV.read(csv_file, headers: true, skip_blanks: true, :encoding => 'windows-1251:utf-8')
      @requests = []

      info "Parsing File"
      csv.each_with_index do |row, index|

        data = column_matchers.map do |column, key|
          [key, row[column]]
        end.to_h

        if data.values.none?
          info "skipping row"
          next
        end

        request = ::RefundRequest.new(data)

        request.api_url = 'https://api.pin.net.au'

        if request.pin?
          @requests << request
        end
      end
      info "Parsed: rows=#{@requests.count}"
      @requests
    end


    def fetch_spree_objects
      info "Setting Spree relations"
      @requests.map(&:set_spree_relations)
    end

    # Old Pin credentials were overwritten when we switched to the new Account.
    def payment_gateways
      [{
         :name       => "PIN Payments USD OLD",
         :public_key => "pk_NxLgEbIIaWwjKEqUnTd6oA",
         :secret_key => "n0_Zr18cz5MvZtuA3BQ7rg",
         :test_mode  => false,
         :server     => "prod",
         :AUD        => 3,
         :USD        => 1
       },
       {
         :name       => "PIN Payments AUD OLD",
         :public_key => "pk_L2WMz5flarYdBZnHCsqm9g",
         :secret_key => "AAUDGS1GbfvNELVsJ0GL-A",
         :test_mode  => false,
         :server     => "prod",
         :AUD        => 1,
         :USD        => 3
       },

       {
         :name       => "PIN Payments PROD(NEW)",
         :public_key => "pk__NKdn1rU22OxI1KQUwx85g",
         :secret_key => "rgqW1Pf47HHzDj4dsuNZqg",
         :test_mode  => false,
         :server     => "prod",
         :AUD        => 2,
         :USD        => 2
       }]
    end


    def find_correct_gateway_and_charge
      info "Finding Original Charged Gateway"
      total = requests.count
      requests.each_with_index do |request, idx|
        PinPayment.api_url = request.api_url

        currency = request.currency.to_sym

        payment_gateways.sort_by { |gw| gw[currency] }.each do |gateway|
          if request.secret_key.present?
            next
          end

          PinPayment.public_key = gateway[:public_key]
          PinPayment.secret_key = gateway[:secret_key]

          begin
            charge = PinPayment::Charge.find(request.payment_ref)

            if charge
              request.public_key = gateway[:public_key]
              request.secret_key = gateway[:secret_key]

              request.set_from_charge(charge)

              refund = charge.refunds.first
              if refund
                request.set_refund(refund)
              end

              info "FOUND:#{idx}/#{total} - #{request.payment_ref} on #{gateway[:name]}"
            end

          rescue PinPayment::Error => e
            if e.message == "The requested resource could not be found."
              warn "NOT_FOUND: #{request.payment_ref}"
              next
            else
              raise e
            end
          end
        end
      end
    end

    def save_all
      requests.map &:save!
    end
  end
end
