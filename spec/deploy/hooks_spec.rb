require 'spec_helper'
require 'rspec/shell/expectations'


describe 'deploy hook script:' do
  include Rspec::Shell::Expectations

  let!(:stubbed_env) { create_stubbed_env }
  let(:server_role) { 'not-exist' }
  let(:framework_env) { 'not-exist' }
  let(:env_vars) do
    { 'SERVER_ROLE' => server_role, 'FRAMEWORK_ENV' => framework_env, 'current_app_path' => Rails.root.to_s, 'this_release_dir' => Rails.root.to_s }
  end
  let(:servers) do
  end

  before(:each) do
    stubbed_env.stub_command('curl')
    stubbed_env.stub_command('zdd_unicorn')
    stubbed_env.stub_command('wheneverize_worker')
    stubbed_env.stub_command('mkdir')
    stubbed_env.stub_command('ln')
    stubbed_env.stub_command('git')
    stubbed_env.stub_command('awk')
    stubbed_env.stub_command('npm')
    
    yarn_stub = stubbed_env.stub_command('yarn')
    yarn_stub.with_args('install')
    yarn_stub.with_args('run', 'prod')

    bundler_stub = stubbed_env.stub_command('bundle')
    bundler_stub.with_args('exec', 'rake', 'cache:clear')
  end

  hooks_pattern = File.join(Rails.root.join('config/deploy/hooks'), '**', '*.sh')
  Dir.glob(hooks_pattern).each do |hook_path|
    describe "'#{hook_path}'" do
      [
        { role: 'web', env: 'staging' },
        { role: 'web', env: 'production' },
        { role: 'worker', env: 'staging' },
        { role: 'worker', env: 'production' }
      ].each do |server|
        context "for server with role '#{server[:role]}' and env '#{server[:env]}'" do
          let(:server_role) { server[:role] }
          let(:framework_env) { server[:env] }
          it 'should not fail' do
            stdout, stderr, status = stubbed_env.execute(
              "/bin/bash #{hook_path}",
              env_vars
            )

            expect(stderr).to be_empty
            expect(status.exitstatus).to be_zero
          end
        end
      end
    end
  end

end
