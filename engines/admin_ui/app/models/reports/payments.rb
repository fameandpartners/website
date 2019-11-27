require 'delegate'
require 'enumerable_csv'
module Reports
  class Payments
    include EnumerableCSV

    attr_accessor :from, :to

    def initialize(from:, to:)
      raise ArgumentError unless from.respond_to?(:to_date)
      raise ArgumentError unless to.respond_to?(:to_date)

      @from = from.to_datetime.beginning_of_day
      @to = to.to_datetime.end_of_day
    end

    def description
      'Payments'
    end

    def each
      return to_enum(__callee__) unless block_given?

      # Deleted Payment Methods are excluded by the default join scope,
      # wrapping the entire report query in the `unscoped` block will solve this.
      #
      # Default scopes, not even once.
      #
      # The original version of this did a fixup of missing methods after the fact.
      #     payment.payment_method = Spree::PaymentMethod.unscoped.find(payment.payment_method_id)
      Spree::PaymentMethod.unscoped do
        report_query.find_each(batch_size: 500) do |order|
          order.payments.each do |payment|
            yield PaymentReportPresenter.from_payment(payment)
          end
        end
      end
    end

    def report_query
      Spree::Order.unscoped
          .completed
          .includes(:payments => [:payment_method, :source]).includes(:shipments).where('completed_at between ? and ?', @from, @to)
    end

    class PaymentReportPresenter < SimpleDelegator

      def self.from_payment(payment)
        Types.const_get(payment.payment_method.type.demodulize, false).new(payment)
      rescue NoMethodError
        payment.payment_method = Spree::PaymentMethod.unscoped.find(payment.payment_method_id)
        from_payment(payment)
      end

      def amount_in_cents
        (amount * 100).to_i
      end

      def payment_date
        created_at.try(:to_date).to_s
      end

      def timestamp
        created_at
      end

      def ident
        identifier
      end

      def token
        response_code
      end

      def card_type
        return 'Missing Card' if source.nil?
        source.cc_type
      end

      def order_number
        order.number
      end

      def order_state
        order.state
      end

      def order_shipped?
        order.shipped?
      end

      def order_email
        order.email
      end

      def order_name
        order.name
      end

      def order_country
        order.ship_address.try(:country)
      end

      def order_created
        order.created_at.try(:to_date).to_s
      end

      def shipment_tracking_numbers
        order.shipments.collect(&:tracking).join(',')
      end

      def first_shipment
        order.shipments.order(:shipped_at).first.shipped_at.to_s if order.shipments.present?
      end

      def last_shipment
        order.shipments.order(:shipped_at).last.shipped_at.to_s if order.shipments.present?
      end

      def to_h
        {
            payment_date:              payment_date,
            ident:                     ident,
            payment_type:              payment_type,
            token:                     token,
            payer_id:                  payer_id,
            transaction_id:            transaction_id,
            card_type:                 card_type,
            payment_state:             state,
            amount:                    amount,
            currency:                  currency,
            order_number:              order_number,
            order_created:             order_created,
            order_email:               order_email,
            order_name:                order_name,
            order_country:             order_country,
            order_state:               order_state,
            order_shipped:             order_shipped?,
            shipment_tracking_numbers: shipment_tracking_numbers,
            first_shipment:            first_shipment,
            last_shipment:             last_shipment,
            timestamp:                 timestamp,
        }
      end

      module Types
        class PayPalExpress < PaymentReportPresenter
          def payment_type
            'PayPal'
          end

          def token
            source.token
          end

          def payer_id
            source.payer_id
          end

          def transaction_id
            source.transaction_id
          end

          def card_type
            'paypal'
          end
        end

        class Pin < PaymentReportPresenter
          def payment_type
            'Pin'
          end

          def payer_id
            return 'Missing Payer' if source.nil?
            source.gateway_payment_profile_id
          end

          def transaction_id
            token
          end
        end

        class FameStripe < PaymentReportPresenter
          def payment_type
            'FameStripe'
          end

          def payer_id
            return 'Missing Payer' if source.nil?
            source.gateway_payment_profile_id
          end

          def transaction_id
            token
          end
        end

        class ApplePayStripe < PaymentReportPresenter
          def payment_type
            'ApplePayStripe'
          end

          def payer_id
            return 'Missing Payer' if source.nil?
            source.gateway_payment_profile_id
          end

          def transaction_id
            token
          end
        end

        class AfterpayPayment < PaymentReportPresenter
          def payment_type
            'AfterPay'
          end

          def payer_id
            return 'Missing Payer' if source.nil?
            source.gateway_payment_profile_id
          end

          def transaction_id
            token
          end
        end

        class NabTransactGateway < PaymentReportPresenter
          def payment_type
            'NABTransact'
          end

          def payer_id
            [source.first_name, source.last_name].join(' ')
          end

          def transaction_id
            '-'
          end
        end
      end
    end
  end
end
