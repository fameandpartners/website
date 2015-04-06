# Turns on global features
require 'redis'
if Rails.env.production?
  Features.deactivate(:style_quiz)
else
  Features.activate(:style_quiz)
end
Features.deactivate(:collection_content)
Features.deactivate(:maintenance)
Features.deactivate(:express_deliveries)
Features.activate(:moodboard)
Features.activate(:sales)
Features.activate(:sales)
