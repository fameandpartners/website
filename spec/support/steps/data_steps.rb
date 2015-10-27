module Acceptance
  module DataSteps
    DUMP_FILE     = Rails.root.join('spec', 'fixtures', 'database_snapshots', 'minified_production_data.dump')
    TEST_DATABASE = Rails.configuration.database_configuration['test']

    # User           => email: spree@example.com, password: 123456
    # Product        => name: Connie, id: 681
    # Payment Method => PIN test
    step 'A sample database with valid data' do
      %x( pg_restore -d #{TEST_DATABASE['database']} --clean --if-exists --jobs 8 --no-acl -U #{TEST_DATABASE['username']} #{DUMP_FILE} )
    end

    step 'Data is setup correctly' do
      ClearCacheWorker.new.perform
      Utility::Reindexer.reindex
    end
  end
end

RSpec.configure { |c| c.include Acceptance::DataSteps, type: :feature }
