# Turns on global features
require 'redis'
if Rails.env.development?
  Features.activate(:content_revolution)
end

if Rails.env.production?
  Features.deactivate(:style_quiz)
else
  Features.activate(:style_quiz)
end

Features.deactivate(:collection_content)
Features.deactivate(:maintenance)
Features.deactivate(:sales)
Features.activate(:express_making)
Features.activate(:moodboard)
Features.activate(:order_returns)
