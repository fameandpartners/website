require 'capybara-screenshot/rspec'

Capybara::Screenshot.autosave_on_failure = true
Capybara::Screenshot.prune_strategy      = :keep_last_run

