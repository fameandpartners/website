require 'customerio'

# A very thin wrapper around the CustomerIO Client
# Automatically extracts spree user details & id
module Marketing
  class CustomerIOEventTracker
    def identify_user(user, site_version)
      client.identify(customer_ident_hash(user, site_version))
    end

    def delete_user(user)
      client.delete(user.id)
    end

    def track(user, event_type, attrs)
      client.track(user.id, event_type, attrs)
    end

    # @api internal
    def client
      @client ||= Customerio::Client.new(site_id, api_key, json: true)
    end

    # @api internal
    def customer_ident_hash(user, site_version)
      {
        id:           user.id,
        email:        user.email,
        created_at:   user.created_at.to_i,
        first_name:   user.first_name,
        last_name:    user.last_name,
        site_version: site_version.code,
      }
    end

    private def api_key
      configatron.customerio.secret_key
    end

    private def site_id
      configatron.customerio.site_id
    end
  end
end
