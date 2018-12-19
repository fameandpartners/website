class ItemReturnSerializer < ActiveModel::Serializer
    attributes :id, :refunded_at, :refund_amount, :comments, :label_image_url, :label_pdf_url, :label_url, :created_at, :refund_status, :acceptance_status, :request_id

    def tracking_number
        object.tracking
    end

    def label_image_url
        object.item_return_label&.label_image_url
    end

    def label_pdf_url
        object.item_return_label&.label_pdf_url
    end

    def label_url
        object.item_return_label&.label_url
    end

    def request_id
      ReturnRequestItem.find_by_id(object.request_id).order_return_request_id
    end

end