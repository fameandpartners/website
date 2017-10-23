require 'rack/proxy'
class WebpackProxy < Rack::Proxy
  def perform_request(env)
    request = Rack::Request.new(env)
    if request.path =~ /dresses\/dresses-|static\/js/
      env['HTTP_HOST'] = 'localhost:3030'
      env['REQUEST_PATH'] = request.fullpath
      super(env)
    else
      @app.call(env)
    end
  end
end
