# Source: https://github.com/spree/spree/blob/1-3-stable/core/lib/spree/core/ssl_requirement.rb
module SslRequirement
  private def ssl_supported?
    return Spree::Config[:allow_ssl_in_staging] if Rails.env.preproduction?
    return Spree::Config[:allow_ssl_in_production] if Rails.env.production?
    return Spree::Config[:allow_ssl_in_staging] if Rails.env.staging?
    return Spree::Config[:allow_ssl_in_development_and_test] if (Rails.env.development? or Rails.env.test?)
  end
end
