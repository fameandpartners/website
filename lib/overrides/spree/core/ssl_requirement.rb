# Source: https://github.com/spree/spree/blob/1-3-stable/core/lib/spree/core/ssl_requirement.rb
module SslRequirement
  # Source: https://github.com/spree/spree/blob/1-3-stable/core/lib/spree/core/ssl_requirement.rb#L102-L112
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
