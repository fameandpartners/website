# Turns on global features
require 'redis'
Features.deactivate(:style_quiz)
Features.deactivate(:collection_content)
Features.activate(:moodboard)
