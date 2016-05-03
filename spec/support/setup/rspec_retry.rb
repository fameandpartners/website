# ENV variables avaialble:
# RSPEC_RETRY_RETRY_COUNT, which sets the default value of retries. Default: 1
# RSPEC_RETRY_RETRY_COUNT_FOR_FEATURES, which sets the number of retries for type: :feature specs. Default to 3

require 'rspec/retry'

RSpec.configure do |config|
  # show retry status in spec process
  config.verbose_retry                = true
  # show exception that triggers a retry if verbose_retry is set to true
  config.display_try_failure_messages = true

  # run retry only on features
  config.around :each, type: :feature do |ex|
    ex.run_with_retry retry: ENV.fetch('RSPEC_RETRY_RETRY_COUNT_FOR_FEATURES', '3').to_i
  end
end
