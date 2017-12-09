require 'rack/proxy'
class WebpackProxy < Rack::Proxy
  def perform_request(env)
    request = Rack::Request.new(env)
    if request.path =~ /webpack/
      env['HTTP_HOST'] = configatron.node_pdp_url
      env['REQUEST_PATH'] = request.fullpath
      super(env)
    else
      @app.call(env)
    end
  end
end
