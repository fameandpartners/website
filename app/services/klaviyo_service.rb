require 'rest-client'

class KlaviyoService
  attr_reader :service, :email,
              :previous_email, :newsletter, :first_name,
              :last_name, :current_sign_in_ip,
              :landing_page, :utm_params, :site_version,
              :facebook_uid, :form_name

  def initialize(options = {}, email:, previous_email: nil, newsletter: nil,
                 first_name: nil, last_name: nil, current_sign_in_ip:, landing_page:,
                 utm_params: nil, site_version:, facebook_uid: nil, form_name:)

    @service            = options[:service] ? options[:service].to_sym : :bronto
    @email              = email
    @previous_email     = previous_email
    @newsletter         = newsletter
    @first_name         = first_name
    @last_name          = last_name
    @current_sign_in_ip = current_sign_in_ip
    @landing_page       = landing_page
    @utm_params         = utm_params
    @site_version       = site_version
    @facebook_uid       = facebook_uid
    @form_name          = form_name
  end

  def subscribe_list
    make_post_request("#{configatron.klaviyo_api_endpoint}/v2/list/#{configatron.klaviyo_list}/subscribe", {
      api_key: configatron.klaviyo_token,
      profiles: [
        {
          email: email,
          first_name: first_name,
          last_name: last_name
        }
      ]
    })
  end

  def make_post_request(url, body)
    begin
      return RestClient.post(url, body.to_json, { content_type: :json })
    rescue RestClient::ExceptionWithResponse => e
      Raven.capture_exception(e, extra: { url: url, body: body })
    end
  end
end
