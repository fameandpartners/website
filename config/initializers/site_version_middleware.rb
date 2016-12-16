require 'middleware/site_version/detector'

FameAndPartners::Application.configure do |config|
  config.middleware.insert_after ActionDispatch::DebugExceptions, Middleware::SiteVersion::Detector
end
