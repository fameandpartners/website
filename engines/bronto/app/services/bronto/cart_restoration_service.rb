module Bronto
    module CartRestorationService
        require 'json'
        require 'rest-client'

        class << self

            def access_token
                if @access_token.nil? or access_token_expired?
                    get_access_token
                end

                return @access_token
            end

            def get_access_token
                response = make_post_request("#{configatron.bronto.rest_api_auth_endpoint}", {
                    grant_type: 'client_credentials',
                    client_id: "#{configatron.bronto.rest_client_id}",
                    client_secret: "#{configatron.bronto.rest_client_secret}"
                })

                unless response.nil?
                    json_obj = JSON.parse(response)
                    
                    @access_token_expires_at = Time.now + json_obj['expires_in']
                    @access_token = json_obj['access_token']
                end
            end

            def access_token_expired?
                unless @access_token_expires_at.nil? 
                    @access_token_expires_at <= (Time.now - 5*60) # 5 minute buffer 
                else 
                    false
                end
            end

            def make_get_request(url)
                begin
                    return RestClient.get("#{url}", content_type: 'application/json', authorization: "Bearer #{access_token}")
                rescue RestClient::ExceptionWithResponse => e
                    # e,response.code
                    Raven.capture_exception(e, extra: { url: url })
                end
            end

            def make_post_request(url, body)
                begin
                    return RestClient.post(url, body)
                rescue RestClient::ExceptionWithResponse => e
                    Raven.capture_exception(e, extra: { url: url })
                end
            end

            def get_abandoned_cart(cart_id)
                cart = make_get_request("#{configatron.bronto.rest_api_endpoint}/carts/#{cart_id}")

                unless cart.nil?
                    JSON.parse(cart)
                else
                    cart
                end
            end
        end
    end
end