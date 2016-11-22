require 'middleware/site_version/detector'

FameAndPartners::Application.configure do |config|
  if defined? ActionDispatch::DebugExceptions
    config.middleware.insert_after ActionDispatch::DebugExceptions, Middleware::SiteVersion::Detector
  else
    config.middleware.use Middleware::SiteVersion::Detector
  end
end
