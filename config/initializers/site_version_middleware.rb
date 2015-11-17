require 'middlewares/site_version/detector'

FameAndPartners::Application.configure do |config|
  config.middleware.insert 0, Middleware::SiteVersion::Detector
end
