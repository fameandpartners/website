module Bergen
  module Operations
    class OpenReturnRequest
      class << self
        def process(return_request_items:)
          service.style_master_product_add_by_return_request_items(return_items: return_request_items)
        end

        private def service
          Bergen::Service.new
        end
      end
    end
  end
end
