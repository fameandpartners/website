require 'capybara-screenshot/rspec'

Capybara::Screenshot.autosave_on_failure = true
Capybara::Screenshot.prune_strategy      = :keep_last_run

# Uncomment this for quick binding.pry in acceptance specs.
# RSpec.configure do |config|
#   config.after(:each, :type => :feature) do |example|
#     if example.exception
#       binding.pry
#     end
#   end
# end
