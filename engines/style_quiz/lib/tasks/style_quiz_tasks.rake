# desc "Explaining what the task does"
# task :style_quiz do
#   # Task goes here
# end
#
namespace :style_quiz do
  desc "Populate database with default style quiz data"
  task populate: :environment do
    require File.join(StyleQuiz::Engine.root, 'db', 'seeds.rb')
    StyleQuiz::Seed.new.populate
  end
end
