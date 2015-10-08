if defined?(WebMock)
  WebMock.allow_net_connect!(net_http_connect_on_start: true)
end
