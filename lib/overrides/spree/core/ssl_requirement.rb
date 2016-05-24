# Source: https://github.com/spree/spree/blob/1-3-stable/core/lib/spree/core/ssl_requirement.rb
module SslRequirement
  private def ssl_supported?
    return Spree::Config[:allow_ssl_in_staging] if Rails.env.preproduction?
    return Spree::Config[:allow_ssl_in_production] if Rails.env.production?
    return Spree::Config[:allow_ssl_in_staging] if Rails.env.staging?
    return Spree::Config[:allow_ssl_in_development_and_test] if (Rails.env.development? or Rails.env.test?)
  end

  def ensure_proper_protocol
    return true if ssl_allowed?
    if ssl_required? && !request.ssl? && ssl_supported?
      redirect_to 'https://' + request.host + request.fullpath, status: :moved_permanently
      flash.keep
    elsif request.ssl? && !ssl_required?
      redirect_to 'http://' + request.host + request.fullpath, status: :moved_permanently
      flash.keep
    end
  end
end
