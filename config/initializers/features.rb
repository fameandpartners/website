# Turns on global features
require 'redis'
if Rails.env.production?
end

Features.deactivate(:style_quiz)
Features.deactivate(:collection_content)
Features.deactivate(:maintenance)
Features.deactivate(:sales)
Features.activate(:express_making)
Features.activate(:moodboard)
Features.activate(:order_returns)
