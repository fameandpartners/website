# Turns on global features
require 'redis'
if Rails.env.production?
  Features.deactivate(:order_returns)
else
  Features.activate(:order_returns)
end

Features.deactivate(:style_quiz)
Features.deactivate(:collection_content)
Features.deactivate(:maintenance)
Features.deactivate(:express_deliveries)
Features.activate(:moodboard)
Features.activate(:sales)
