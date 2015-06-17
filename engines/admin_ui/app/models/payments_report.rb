require 'delegate'
require 'csv'

class PaymentsReport
  def report
    to_csv_rows.each do |row|
      puts row
    end
  end

  def to_csv_rows
    return to_enum(__callee__) unless block_given?

    streaming.each_with_index do |payment, idx|
      data = payment.to_h

      if idx.zero?
        yield CSV::Row.new(data.keys, data.keys, true)
      end

      yield CSV::Row.new(data.keys, data.values)
    end
  end

  def streaming
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
      .includes(:payments => [:payment_method, :source]).includes(:shipments)
  end

  class PaymentReportPresenter < SimpleDelegator

    def self.from_payment(payment)
      Types.const_get(payment.payment_method.type.demodulize, false).new(payment)
    end

    def payment_date
      created_at.try(:to_date).to_s
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

    def order_created
      order.created_at.try(:to_date).to_s
    end

    def shipment_tracking_numbers
      order.shipments.collect(&:tracking).join(',')
    end

    def to_h
      {
        payment_date:              payment_date,
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
        order_state:               order_state,
        order_shipped:             order_shipped?,
        shipment_tracking_numbers: shipment_tracking_numbers
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
          '-'
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
