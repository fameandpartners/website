if Rails.env.test?
  HTTPI.log = false
end

if ENV.fetch('HTTPI_ENABLE_LOGS', false)
  HTTPI.log = true
end
