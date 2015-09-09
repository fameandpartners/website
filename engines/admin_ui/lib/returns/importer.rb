module Returns
  class Importer < ::Importers::FileImporter
    def import
      preface

      csv = CSV.read(csv_file, headers: true, skip_blanks: true)

      info "Parsing File"

      ManuallyManagedReturn.transaction do
        csv.each_with_index do |row, index|
          # 0 Indexed rows + Header = 2
          row_number = (index + 2).to_s

          row_data = {
            :row_number                 => row_number,
            :rj_ident                   => row['PK for RJMetrics'],
            :column_b                   => row.to_a[1].last, # No Key, direct idx
            :receive_state              => row['Received'],
            :spree_order_number         => row['Spree Order Number'],
            :return_cancellation_credit => row['RETURN OR CANCELLATION OR STORE CREDIT'],
            :name                       => row['Name'],
            :order_date                 => row['ORDER DATE'],
            :order_month                => row['ORDER MONTH'],
            :return_requested_on        => row['RETURN REQUEST'],
            :comments                   => row['COMMENTS'],
            :product                    => row['PRODUCT'],
            :size                       => row['SIZE'],
            :colour                     => row['COLOUR'],
            :return_category            => row['CATEGORY'],
            :return_sub_category        => row['SUB CATEGORY'],
            :return_office              => row['RETURN OFFICE'],
            :received                   => row['DRESS RECEIVED'],
            :in_inventory               => row['IN INVENTORY'],
            :notes                      => row['NOTES'],
            :restocking                 => row['Restocking?'],
            :returned_to_factory        => row['Returned to Factory'],
            :refund_status              => row['REFUND STATUS'],
            :payment_method             => row['PAYMENT METHOD'],
            :refund_method              => row['REFUND METHOD'],
            :currency                   => row['CURRENCY'],
            :amount_paid                => row['AMOUNT PAID'],
            :spree_amount_paid          => row['Spree Amount Paid'],
            :refund_amount              => row['REFUND AMOUNT'],
            :date_refunded              => row['DATE REFUNDED'],
            :email                      => row['EMAIL'],
            :account_name               => row['ACCOUNT NAME'],
            :account_number             => row['ACCOUNT NUMBER'],
            :account_bsb                => row['ACCOUNT BSB'],
            :account_swift              => row['ACCOUNT SWIFT CODE'],
            :customers_notes            => row['CUSTOMER NOTES'],
            :quantity                   => row['QTY'],
            :deleted_row                => row['Deleted']
          }


          info [row_data[:rj_ident], row_data[:spree_order_number] ].join(' ')
          ManuallyManagedReturn.find_or_create_by_row_number(row_number) do |mmr|
            mmr.assign_attributes(row_data)
          end
        end
      end
      info "Done"
    end
  end
end
