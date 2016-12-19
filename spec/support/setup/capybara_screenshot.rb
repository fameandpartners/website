require 'capybara-screenshot/rspec'

Capybara::Screenshot.autosave_on_failure = true
Capybara::Screenshot.prune_strategy      = :keep_last_run
Capybara.save_and_open_page_path = ::Rails.root.join('tmp', 'capybara')

