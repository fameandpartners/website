module Acceptance
  module FeatureFlagsSteps
    FLAGS_ENABLED_BY_DEFAULT= %i(
                                fameweddings
                                height_customisation
                                moodboard
                              )

    step 'Setup default feature flags' do
      FLAGS_ENABLED_BY_DEFAULT.each { |ff| Features.activate(ff) }
    end

    step 'The ":feature_name" feature is enabled' do |feature|
      Features.activate(feature.to_s.to_sym)
    end

    step 'The ":feature_name" feature is disabled' do |feature|
      Features.deactivate(feature.to_s.to_sym)
    end
  end
end

RSpec.configure { |c| c.include Acceptance::FeatureFlagsSteps, type: :feature }
