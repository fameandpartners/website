require 'rack/proxy'

class WebpackProxy < Rack::Proxy
  def perform_request(env)
    request = Rack::Request.new(env)
    if (
        request.path =~ configatron.fame_webclient_always_regex ||
        (request.path =~ configatron.fame_webclient_pdp_regex && Features.active?(:new_pdp)) ||
        (request.path =~ configatron.fame_webclient_content_regex && Features.active?(:new_content)) ||
        (request.path =~ configatron.fame_webclient_category_regex && Features.active?(:new_category_page)) ||
        (request.path =~ configatron.fame_webclient_account_regex && Features.active?(:new_account))
      )
      backend = URI(configatron.fame_webclient_url)
      env['HTTP_X_FAME_FORWARDED_HOST'] = env['HTTP_X_FORWARDED_HOST'] || env['HTTP_HOST']
      env['HTTP_X_FAME_FORWARDED_PROTO'] = env['HTTP_X_FORWARDED_PROTO'] || env['rack.url_scheme']
      env['HTTP_HOST'] = "#{backend.host}:#{backend.port}"
      env['REQUEST_PATH'] = request.fullpath.sub("dresses-new", "dresses")
      super(env)
    else
      @app.call(env)
    end
  end
end
