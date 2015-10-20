# debug tools
# page.driver.debug # if inspector true
# save_and_open_screenshot
# save_and_open_page
# save_screenshot('screenshot.png', full: true)
# ..
module AcceptanceHelpers
  def ignore_js_errors
    yield
  rescue Capybara::Poltergeist::JavascriptError
    # do nothing
  end

  def wait_ajax_completion(page)
    Timeout.timeout(Capybara.default_wait_time) do
      until page.evaluate_script('jQuery.active').zero? do
        sleep(0.1)
      end
      sleep(0.5) # additional time to process & render
    end
  end

  def select_from_chosen(option_value, options)
    field = find_field(options[:from], visible: false)
    page.execute_script("$('##{field[:id]}').val('#{option_value}')")
    page.execute_script("$('##{field[:id]}').trigger('chosen:updated').trigger('change')")
  end

  # behaviour tests
  # don't forgot to clear traffic before
  #   page.driver.clear_network_traffic
  def show_network_traffic(page)
    page.driver.network_traffic.each do |request|
      request.response_parts.uniq(&:url).each do |response|
        puts "\n Response URL #{response.url}: \n Status #{response.status}"
      end
    end
  end
end

RSpec.configure do |config|
  config.include AcceptanceHelpers, type: :feature
end
