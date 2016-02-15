module Acceptance
  module DataSteps
    DUMP_FILE     = Rails.root.join('spec', 'fixtures', 'database_snapshots', 'minified_production_data.dump')
    TEST_DATABASE = Rails.configuration.database_configuration['test']

    # TODO: Specs should be factory based, not database restored.
    # User           => email: spree@example.com, password: 123456
    # Product        => name: Connie, id: 681
    # Payment Method => PIN test
    step 'A sample database with valid data' do
      %x( pg_restore -d #{TEST_DATABASE['database']} --clean --if-exists --jobs 8 --no-acl -U #{TEST_DATABASE['username']} #{DUMP_FILE} )
    end

    step 'Data is setup correctly' do
      ClearCacheWorker.new.perform(silent: true)
    end

    step 'the ":feature_name" feature is enabled' do |feature|
      Features.activate(feature.to_s.to_sym)
    end

    step 'the ":feature_name" feature is disabled' do |feature|
      Features.deactivate(feature.to_s.to_sym)
    end
  end
end

RSpec.configure { |c| c.include Acceptance::DataSteps, type: :feature }
