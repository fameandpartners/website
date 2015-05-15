# Turns on global features
require 'redis'
if Rails.env.production?
end

Features.deactivate(:style_quiz)
Features.deactivate(:collection_content)
Features.deactivate(:maintenance)
Features.deactivate(:express_deliveries)
Features.activate(:moodboard)
Features.activate(:sales)
Features.activate(:order_returns)
