class MasterpassData
  attr_accessor :payment_method_id,

                :request_token,

                :verifier,
                :checkout_resource_url,

                :pairing_token,
                :pairing_verifier,
                :long_access_token,
                :long_access_token_response,

                :access_token,
                :access_token_response,

                :checkout,

                :error_message

end