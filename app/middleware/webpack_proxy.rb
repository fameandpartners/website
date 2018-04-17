require 'rack/proxy'

class WebpackProxy < Rack::Proxy
  def perform_request(env)
    request = Rack::Request.new(env)
    if request.path =~ /webpack/
      env['HTTP_HOST'] = configatron.node_pdp_url
      env['REQUEST_PATH'] = request.fullpath
      super(env)
    elsif Features.active?(:new_pdp) && request.path =~ configatron.fame_webclient_regex
      backend = URI(configatron.fame_webclient_url)

      env['HTTP_HOST'] = "#{backend.host}:#{backend.port}"
      env['REQUEST_PATH'] = request.fullpath.sub("dresses-new", "dresses")
      super(env)
    else
      @app.call(env)
    end
  end
end
