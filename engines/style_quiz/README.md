Fame&Partners Style Quiz
=======================

# installation:

create database schema
`rake style_quiz:install:migrations`

run migrations
`rake db:migrate`

populate with default questions
`rake style_quiz:populate`

# troubleshooting:

update products indexes
`StyleQuiz::ProductStyleProfileIndex.update_all`

reupdate answers
`
  load File.join(StyleQuiz::Engine.root, 'db', 'seeds.rb')
  StyleQuiz::Seed.new.populate(force: true)
`
