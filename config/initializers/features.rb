# Turns on global features 
require 'redis'
Features.deactivate(:style_quiz)
Features.activate(:moodboard)