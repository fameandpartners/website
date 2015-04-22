module SmokeTestSteps
  step 'I am testing against production' do
    Capybara.app_host = "http://www.fameandpartners.com"
  end
  step 'I am testing against localhost' do
    Capybara.app_host = "http://localhost:3000"
  end

  step 'I am testing against pre-production' do
    Capybara.app_host = "http://preprod.fameandpartners.com"
  end
end

RSpec.configure { |c| c.include SmokeTestSteps }



