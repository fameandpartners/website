require 'rack/proxy'
class WebpackProxy < Rack::Proxy
  def perform_request(env)
    request = Rack::Request.new(env)
    if request.path =~ /dresses\/dress-|static\/js/
      env['HTTP_HOST'] = 'localhost:8001'
      env['REQUEST_PATH'] = request.fullpath
      super(env)
    else
      @app.call(env)
    end
  end
end
